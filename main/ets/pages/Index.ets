import { MapComponent, mapCommon, map } from '@kit.MapKit';
import { AsyncCallback } from '@kit.BasicServicesKit';
import * as hm from '../ets'
import { Shuju, ResObject, baseimg } from '../http';
import _Pagehalf from '../Component/_Pagehalf'
import _Pagehalf_top from '../Component/_Pagehalf_top'
import _Jianzhu from '../model/jianzhu';
import _Zhandian from '../model/zhandian';
import { _Imgutil } from '../imgutil'
import * as modal from '../Component/CustomDialogs'
import { geoLocationManager } from '@kit.LocationKit';
import {_ren} from '../data/img'
import { navi } from '@kit.MapKit';
import Tabitem from '../model/tab'
import huodong from '../views/huodong'
import tongzhi from '../views/tongzhi'
import user from '../views/user'



const s = new Shuju();
const page = new hm.page();

let jzn = 0; //批量增加建筑标记点的时候用的

class pagejz {
  jid: string = ""
}

@Entry
@Component
struct Index {
  //地图用的
  private TAG = "HuaweiMapDemo";
  private mapOptions?: mapCommon.MapOptions;
  private callback?: AsyncCallback<map.MapComponentController>;
  private mapController?: map.MapComponentController;
  private mapEventManager?: map.MapEventManager;

  private daohangpolyline?:map.MapPolyline;

  @State jzs: Array<_Jianzhu> = [];
  @State zds: Array<_Zhandian> = [];
  @State zdmarker: Array<map.Marker> = new Array();  //校车运动的
  @State zdmarker2: Array<map.Marker> = new Array(); //站点的

  @State zxlat: number = 0;
  @State zxlng: number = 0;

  //我的定位
  @State mylat :number = 0;
  @State mylng :number = 0;
  @State mymarker:Array<map.Marker> = [];

  //导航栏
  tabs: Array<Tabitem> = [
    new Tabitem('首页', $r("app.media.icon_home")),
    new Tabitem('活动', $r("app.media.icon_huodong")),
    new Tabitem('通知', $r("app.media.icon_tongzhi")),
    new Tabitem('系统', $r("app.media.icon_xitong")),
  ]
  @State choose: number = 0;

  @Builder
  tabBuilder(title: string, targetIndex: number, selectedImg: Resource) {
    Column() {
      Image(selectedImg)
        .size({ width: 30, height: 30 })
      Text(title)
        .fontColor(this.choose === targetIndex ? '#1698CE' : '#6B6B6B')
    }
    .width('100%')
    .height(40)
    .justifyContent(FlexAlign.Center)
    .backgroundColor(Color.White)
  }

  _Initmap() {
    this.mapOptions = {
      position: {
        target: {
          latitude: this.zxlat,
          longitude: this.zxlng
        },
        zoom: 17
      }
    };

    // 地图初始化的回调
    this.callback = async (err, mapController) => {
      if (!err) {
        // 获取地图的控制器类，用来操作地图
        this.mapController = mapController;
        this.mapEventManager = this.mapController.getEventManager();
        let callback = () => {
          console.info(this.TAG, `on-mapLoad`);

          //获取定位，先要获取权限
          hm._Getquanxian(['ohos.permission.APPROXIMATELY_LOCATION','ohos.permission.LOCATION']).then(()=>{
            let request: geoLocationManager.ContinuousLocationRequest= {
              'interval': 10,  //每10秒刷新一次位置
              'locationScenario': geoLocationManager.UserActivityScenario.NAVIGATION
            }
            //这里开启的是持续定位
            let locationCallback = (location:geoLocationManager.Location):void => {
              let lat = location.latitude;
              let lng = location.longitude;
              //然后要坐标系的转换
              let wgs84Position: mapCommon.LatLng = {
                latitude: lat,
                longitude: lng
              };
              // 转换经纬度坐标
              let gcj02Position: mapCommon.LatLng =
                map.convertCoordinateSync(mapCommon.CoordinateType.WGS84, mapCommon.CoordinateType.GCJ02, wgs84Position);
              this.mylat = gcj02Position.latitude;
              this.mylng = gcj02Position.longitude;
              //获取位置后刷新marker
              this._Setmarker();
            };
            try {
              geoLocationManager.on('locationChange', request, locationCallback);
            } catch (err) {
              console.error("errCode:" + JSON.stringify(err));
            }
          })





        }
        this.mapEventManager.on("mapLoad", callback);
        this.mapController?.on("markerClick", (marker) => {
          let info: _Jianzhu = new _Jianzhu("", "", "");
          for (let i = 0; i < this.jzs.length; i++) {
            if (this.jzs[i].markerid == marker.getId()) {
              info = this.jzs[i];
              break;
            }
          }
          let jzid = info.id;
          if (jzid != "") {
            console.log("applog:点击的图标为" + info.name);
            let tc = new CustomDialogController({
              builder: modal.Dialog1({
                title: info.name,
                arrs: ["详情", "导航"],
                click: async (idx: number) => {
                  if (idx == 0) {
                    page.go("jianzhu_detail", { jid: jzid } as pagejz)
                  }
                  if (idx == 1){
                    this._Daohang(info.lat,info.lng);
                  }
                  tc.close();
                },
                close: () => {
                  tc.close();
                }
              }),
              alignment: DialogAlignment.Center
            })
            tc.open();
          } else {
            console.log("applog:没有点击或者说明点击的是车站")
            for (let i = 0; i < this.zds.length; i++) {
              if (this.zds[i].markerid == marker.getId()) {
                hm.toast(this.zds[i].name);
                break;
              }
            }
          }
        })

      } else {
        console.log("applog:" + JSON.stringify(err));
      }
    };
  }


  //设置我的位置
  async _Setmarker(){
    if(this.mymarker.length == 0){
      let markerOptions: mapCommon.MarkerOptions = {
        position: {
          latitude: this.mylat,
          longitude: this.mylng
        },
        rotation: 0,
        visible: true,
        zIndex: 0,
        alpha: 1,
        anchorU: 0.5,
        anchorV: 1,
        clickable: true,
        draggable: true,
        infoWindowAnchorV: 0,
        flat: false,
        icon: _ren,
        title: "我的位置",
      };

      let marker = await this.mapController?.addMarker(markerOptions);
      // console.log("applog：我的位置更新 " + this.mylat + ";" + this.mylng)

      marker?.setTitle("我的位置")
      marker?.setInfoWindowVisible(true);
      if (marker) {
        this.mymarker.push(marker);
      }
    }else{
      let marker = this.mymarker[0];
      console.log("applog：我的位置更新 " + this.mylat + ";" + this.mylng)

      marker.setPosition({
        latitude:this.mylat,
        longitude:this.mylng
      })
    }
  }

  _Mapmove(lat: number, lng: number) {
    let target: mapCommon.LatLng = {
      latitude: lat,
      longitude: lng
    };
    let cameraPosition: mapCommon.CameraPosition = {
      target: target,
      zoom: 17
    };
    // 新建CameraUpdate对象
    let cameraUpdate: map.CameraUpdate = map.newCameraPosition(cameraPosition);
    // 在1000ms内以动画的形式移动相机
    this.mapController?.animateCamera(cameraUpdate, 1000);
  }

  //这里传入的都是目标坐标
  async _Daohang (lat:number,lng:number){
    if(this.daohangpolyline){
      this.daohangpolyline.remove();
    }
    let params: navi.RouteParams = {
      origins: [{
        latitude: this.mylat,
        longitude: this.mylng
      }],
      destination: {
        latitude: lat,
        longitude: lng
      },
      language: "zh_CN"
    };
    const result = await navi.getCyclingRoutes(params);
    let roads = result.routes[0].steps[0].roads;
    let polyline : Array<mapCommon.LatLng>=[];
    for(let i = 0 ; i < roads.length ; i++){
      let poy = roads[i].polyline;
      polyline = polyline.concat(poy);
    }
    this._Setline(polyline);
    console.log("applog:" + JSON.stringify(result))
  }

  async _Setline(polyline:Array<mapCommon.LatLng>){
    let polylineOption: mapCommon.MapPolylineOptions = {
      points: polyline,
      clickable: true,
      startCap: mapCommon.CapStyle.BUTT,
      endCap: mapCommon.CapStyle.BUTT,
      geodesic: false,
      jointType: mapCommon.JointType.BEVEL,
      visible: true,
      width: 20,
      zIndex: 10,
      gradient: false,
      color:0xff00ff00
    }
    this.daohangpolyline = await this.mapController?.addPolyline(polylineOption);
    this.daohangpolyline?.setCustomTexture($r('app.media.jiantou'));

  }

  aboutToAppear(): void {
    // 地图初始化参数，设置地图中心点坐标及层级

  }

  onPageShow(): void {
    // 将地图切换到前台
    if (this.mapController !== undefined) {
      this.mapController.show();
    }
  }

  // 页面每次隐藏时触发一次，包括路由过程、应用进入后台等场景，仅@Entry装饰的自定义组件生效。
  onPageHide(): void {
    // 将地图切换到后台
    if (this.mapController !== undefined) {
      this.mapController.hide();
    }
  }

  aboutToDisappear(): void {
    //关闭定位
    geoLocationManager.off('locationChange');
  }

  build() {
    Column() {

      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          Column(){
            // 调用MapComponent组件初始化地图
            if (this.zxlat != 0) {
              MapComponent({ mapOptions: this.mapOptions, mapCallback: this.callback }).width('100%').height('100%')
            }
            // _map()

            //最上面的
            _Pagehalf_top({
              sousuo: (lat: number, lng: number) => {
                //把地图定位到这个地方
                console.log('applog:' + lat + ',' + lng)
                this._Mapmove(lat,lng)
              }
            })

            //下半部分
            _Pagehalf({
              _backloc: (lat: number, lng: number) => {
                console.log('applog:' + lat + ',' + lng)
                this.zxlat = lat;
                this.zxlng = lng;
                this._Initmap();
              },
              _backjianzhu: async (jzs: Array<_Jianzhu>) => {
                this.jzs = jzs;
                for (let i = 0; i < jzs.length; i++) {
                  let o = jzs[i];
                  let base64 = await _Imgutil(baseimg + o.img);
                  let markerOptions: mapCommon.MarkerOptions = {
                    position: {
                      latitude: o.lat,
                      longitude: o.lng
                    },
                    rotation: 0,
                    visible: true,
                    zIndex: 0,
                    alpha: 1,
                    anchorU: 0.5,
                    anchorV: 1,
                    clickable: true,
                    draggable: true,
                    infoWindowAnchorV: 0,
                    flat: false,
                    icon: base64,
                    title: o.name,
                  };

                  let marker = await this.mapController?.addMarker(markerOptions);
                  marker?.setTitle(o.name)
                  marker?.setInfoWindowVisible(true);
                  if (marker) {
                    this.jzs[i].markerid = marker.getId();
                  }
                }

              },
              _setzhandian: async (zds: Array<_Zhandian>) => {
                if(this.daohangpolyline){
                  this.daohangpolyline.remove();
                }
                this.zds = zds;
                let points: Array<mapCommon.LatLng> = new Array();
                //先创建一堆站点的markers
                for (let i = 0; i < zds.length; i++) {
                  let o = zds[i];
                  points.push({
                    latitude: parseFloat("" + o.lat),
                    longitude: parseFloat("" + o.lng)
                  })
                  let markerOptions: mapCommon.MarkerOptions = {
                    position: {
                      latitude: o.lat,
                      longitude: o.lng
                    },
                    rotation: 0,
                    visible: true,
                    zIndex: 0,
                    alpha: 1,
                    anchorU: 0.5,
                    anchorV: 1,
                    clickable: true,
                    draggable: true,
                    infoWindowAnchorV: 0,
                    flat: false,
                    icon: $r('app.media.chezhan'),
                    title: o.name,
                  };

                  let markerOptions2: mapCommon.MarkerOptions = {
                    position: {
                      latitude: o.lat,
                      longitude: o.lng
                    },
                    rotation: 0,
                    visible: true,
                    zIndex: 0,
                    alpha: 1,
                    anchorU: 0.5,
                    anchorV: 1,
                    clickable: true,
                    draggable: true,
                    infoWindowAnchorV: 0,
                    flat: false,
                    icon: $r('app.media.xiaoche2'),
                  };

                  let marker = await this.mapController?.addMarker(markerOptions);
                  if (marker) {
                    marker.setTitle(o.name)
                    marker.setInfoWindowVisible(true);
                    this.zds[i].markerid = marker.getId();
                    this.zdmarker2.push(marker);
                  }
                  let marker2 = await this.mapController?.addMarker(markerOptions2);
                  if (marker2) {
                    this.zdmarker.push(marker2);
                  }
                }


                //移动相机到第一个站点
                this._Mapmove(points[0].latitude,points[0].longitude);
                let tranceOptions: mapCommon.TraceOverlayParams = {
                  // 轨迹点
                  points: points,
                  // 轨迹的动画时长
                  animationDuration: 2000,
                  // 相机是否跟随动画移动
                  isMapMoving: true,
                  // 轨迹的颜色
                  color: 0xAAFFAA00,
                  // 轨迹的宽度
                  width: 20,
                  // 轨迹的动画回调（回调轨迹点的index）
                  animationCallback: (pointIndex) => {
                    if(pointIndex == this.zdmarker.length - 1){
                      t?.remove();
                      for (let i = 0; i < this.zdmarker.length; i++) {
                        this.zdmarker[i].remove();
                      }
                      this.zdmarker.length = 0;
                    }
                  }
                }
                console.log("applog:" + JSON.stringify(tranceOptions))
                let t = await this.mapController?.addTraceOverlay(tranceOptions, this.zdmarker);
              },
              _deletezhandian: () => {
                //删除站点
                for (let i = 0; i < this.zdmarker2.length; i++) {
                  this.zdmarker2[i].remove();
                }
                this.zds.length = 0;
                this.zdmarker2.length = 0;
              },
              _daohang: (lat: number, lng: number) => {
                this._Daohang(lat,lng);
              }
            });
          }
        }
        .tabBar(this.tabBuilder(this.tabs[0].text, 0, this.tabs[0].img))

        TabContent() {
          huodong()
        }
        .tabBar(this.tabBuilder(this.tabs[1].text, 1, this.tabs[1].img))

        TabContent() {
          tongzhi()
        }
        .tabBar(this.tabBuilder(this.tabs[2].text, 2, this.tabs[2].img))

        TabContent() {
          user()
        }
        .tabBar(this.tabBuilder(this.tabs[3].text, 3, this.tabs[3].img))
      }
      .onChange((index: number) => {
        this.choose = index;
      })
      .scrollable(false)

    }.height('100%')
    .width('100%')
  }
}

@Component
struct _map {
  build() {
    Column() {

    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.Blue)
    .zIndex(-1)
    .position({ x: 0, y: 0 })
  }
}

