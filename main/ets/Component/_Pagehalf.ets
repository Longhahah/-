
import * as hm from '../ets'
import {Shuju,ResObject,baseimg} from '../http';
import _Quyu from '../model/quyu';
import _Xiaoche from '../model/xiaoche'
import _Jianzhu from '../model/jianzhu'
import _Zhandian from '../model/zhandian'

const s = new Shuju();
const page = new hm.page();

class pagejz{
  jid:string = ""
}
@Entry
@Component
export default struct _Pagehalf {

  //其他的
  private pyset : number = 520;
  @State py  : number = 50;
  // @State py  : number = this.pyset;
  @State choose:number = 0;

  //区域
  @State quyu:Array<_Quyu> = [];
  @State qyitem:_Quyu = new _Quyu("","","");

  //校车
  @State xiaoche:Array<_Xiaoche>=[];
  @State xcitem:_Xiaoche = new _Xiaoche();

  //表示下半部分当前显示的内容，list表示列表，quyu表示某个具体区域
  @State showpage:string = "list";

  //返回去的数据，用来设置中心点的
  _backloc:(lat:number,lng:number)=>void=()=>{}
  //为了导航
  _daohang:(lat:number,lng:number)=>void=()=>{}
  //返回所有建筑数据，为了在桌面上创建建筑
  _backjianzhu:(jzs:Array<_Jianzhu>)=>void=()=>{}
  //返回的选择的路线，即对应的所有途经点集合
  _setzhandian:(zds:Array<_Zhandian>)=>void=()=>{}
  // 删除车站的点
  _deletezhandian:()=>void=()=>{}

  _Getshuju:()=>Promise<string>=()=>{
    return new Promise((succ,err)=>{
      s.g("p/gethome",{
        s:(d:ResObject)=>{
          console.log("applog:" + JSON.stringify(d))
          if(d.code == 200){
            this.quyu = d['quyu'];
            this.xiaoche =d['xiaoche'];
            this._backloc(parseFloat(d['shezhi']['lat']),parseFloat(d['shezhi']['lng']));
            setTimeout(()=>{
              this._backjianzhu(d['jianzhu']);
            },1000)
          }
        }
      })
    })
  }

  aboutToAppear(): void {
    this._Getshuju();
  }


  build() {
    //下面一半的
    Column(){


      Image(this.py == this.pyset ? $r('app.media.xia') : $r('app.media.shang'))
        .width(30).height(30)
        .position({x:"100%",y:15})
        .markAnchor({x:50})
        .zIndex(2)
        .onClick(()=>{
          this.py = this.py == this.pyset ? 50 : this.pyset;
        })


      if(this.showpage != "list" && this.py == this.pyset){
        Image($r('app.media.arr_back'))
          .width(30).height(30)
          .position({x:10,y:15})
          .zIndex(1)
          .onClick(()=>{
            this.showpage = "list";
            this._deletezhandian();
          })
      }


      if(this.showpage == "list"){
        Row(){
          Text(this.choose == 0 ? '区域列表' : '校车列表').fontSize(20).fontWeight('bold')
        }.padding({top:20})

        //选项
        Row({space:80}){
          Text("区域").fontSize(20)
            .borderWidth({bottom:this.choose == 0 ? 5 : 0}).borderColor(Color.Blue)
            .onClick(()=>{this.choose = 0})
          Text("校车").fontSize(20)
            .borderWidth({bottom:this.choose == 1 ? 5 : 0}).borderColor(Color.Blue)
            .onClick(()=>{this.choose = 1})
        }.height(80)
      }
      if(this.showpage == "quyu"){
        Row(){
          Text(this.qyitem.name).fontSize(20).fontWeight('bold')
        }.padding({top:20})
      }

      List(){
        if(this.showpage == "list"){
          ListItem(){
            Column(){
              if(this.choose == 0){
                ForEach(this.quyu,(item:_Quyu,index:number)=>{
                  _Quyuui({
                    info:item,
                    click:()=>{
                      this.qyitem = item;
                      this.showpage = "quyu";
                    }
                  })
                })
              }else{
                ForEach(this.xiaoche,(item:_Xiaoche,index:number)=>{
                  _Xiaocheui({
                    info:item,
                    click:()=>{
                      this.showpage = "xiaoche";
                      this.xcitem = item;
                      let arr :Array<_Zhandian>=[];
                      //获取站点信息
                      s.se('tj','xid');
                      s.se('xid',item.id);
                      s.sb('tujingdian');
                      s.g("c/common_list",{
                        s:(d:ResObject)=>{
                          if(d.code == 200){
                            arr = d['data'] as Array<_Zhandian>
                            this._setzhandian(arr);
                          }
                        }
                      })

                    }
                  })
                })
              }

            }.padding({left:12,right:12,bottom:50})
          }
        }
        if(this.showpage == "quyu"){
          ListItem(){
            //区域详情页
            Column(){
              Image(baseimg + this.qyitem.img)
                .width('100%').height(200).objectFit(ImageFit.Fill)
                .margin({top:15})

              if(this.qyitem.jianzhu.length > 0){
                Column(){
                  _listjz({
                    list:this.qyitem.jianzhu,
                    click:(type:string,id:string)=>{
                      console.log('applog:type:' + type);
                      console.log('applog:id:' + id);
                      if(type == "详情"){
                        page.go("jianzhu_detail",{jid:id} as pagejz)
                      }
                      if(type == "导航"){
                        //获取经纬度坐标
                        s.se("id",id);
                        s.sb("jianzhu");
                        s.g("c/common_detail",{
                          s:(d:ResObject)=>{
                            if(d.code == 200){
                              this._daohang(parseFloat(d['data']['lat']),parseFloat(d['data']['lng']));
                              this.py = 50;
                            }
                          }
                        })
                      }
                    }
                  })
                }.padding(10)
              }else{
                Text("此区域无建筑").fontSize(30)
              }

            }
          }
        }
        if(this.showpage == "xiaoche"){
          ListItem(){
            Column({space:10}){
              Text(this.xcitem.name + "信息").fontSize(25)
              Row()
              Row(){
                Text("始发：" + this.xcitem.shifa).fontSize(25)
              }.width('100%')
              Row(){
                Text("间隔：" + this.xcitem.jiange).fontSize(25)
              }.width('100%')
              Row(){
                Text("末班车：" + this.xcitem.moban).fontSize(25)
              }.width('100%')
            }.padding({top:100,left:30,right:30})
          }
        }
      }
      .width('100%')
      .height(this.pyset)
      .scrollBarWidth(0)

    }.height(this.pyset).width('100%').backgroundColor(Color.White)
    .position({x:0,y:"100%"})
    .markAnchor({y:this.py})
    .borderRadius({topLeft:20,topRight:20})
    .animation({
      duration:200,
      curve:Curve.EaseInOut
    })
  }
}


class quyuui{
  img:string = "";
  name:string = ""
}
@Component
struct _Quyuui {
  @Prop info:quyuui;
  click:()=>void=()=>{}
  build(){
    Stack({alignContent:Alignment.Bottom}){
      Image(baseimg + this.info.img).width('100%').height('100%')
        .borderRadius(10)

      Row(){

      }.backgroundColor('black')
      .height(50)
      .padding({left:10,right:10})
      .width('100%')
      .opacity(0.5)
      .borderRadius(10)
      Text(this.info.name).fontSize(26).fontColor('white')
        .fontWeight('bold').width('100%')
        .margin({left:10,bottom:10})
    }.height(150)
    .width('100%')
    .shadow({
      radius: 10,
      color: '#DCDCDC',
      offsetX: 8,
      offsetY: 10
    })
    .margin({
      bottom:10
    })
    .onClick(()=>{
      this.click()
    })
  }
}


@Component
struct _Xiaocheui {
  @Prop info : _Xiaoche

  click:()=>void=()=>{}
  build(){
    Row(){
      Image($r('app.media.xiaoche')).width(35).height(35)
      Text(this.info.name).fontSize(25).margin({left:10})
    }.width('100%')
    .backgroundColor('white')
    .height(60)
    .shadow({
      radius: 5,
      color: '#DCDCDC',
      offsetX: 8,
      offsetY: 8
    })
    .margin({bottom:3})
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .padding({left:10,right:10})
    .onClick(()=>{
      this.click();
    })
  }
}

@Component
struct _listjz {
  @Prop list : Array<_Jianzhu>;
  private zuo : Array<_Jianzhu> = [];
  private you : Array<_Jianzhu> = [];
  click:(type:string,id:string)=>void=()=>{}

  aboutToAppear(){
    let list = this.list ,zuo:Array<_Jianzhu> = [],you:Array<_Jianzhu> = [];
    for(let i = 0 ; i < list.length ; i++){
      if(i % 2 == 0){
        zuo.push(list[i]);
      }else{
        you.push(list[i]);
      }
    }
    this.zuo = zuo;
    this.you = you;
  }

  build(){
    Row(){
      Column(){
        ForEach(this.zuo,(item:_Jianzhu)=>{
          zuoyouitem({
            info:item,
            click:(type:string,id:string)=>{
              this.click(type,id)
            }
          })
        })
      }.width('46%')
      Column(){
        ForEach(this.you,(item:_Jianzhu)=>{
          zuoyouitem({
            info:item,
            click:(type:string,id:string)=>{
              this.click(type,id)
            }
          })
        })
      }.width('46%')
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceAround)
    .alignItems(VerticalAlign.Top)
  }
}


@Component
export struct zuoyouitem {
  @State gaodu : number = 100;
  @Prop info : _Jianzhu
  click:(type:string,id:string)=>void=()=>{}
  build(){
    Column(){
      Image(baseimg + this.info.img)
        .width('100%')
        .objectFit(ImageFit.Fill)
        .onComplete((e)=>{
          console.log("applog:img:"+this.info.img)
          if(e){
            this.gaodu = (e.componentWidth * e.height) / e.width;
          }
        })
        .height(this.gaodu+"px")
      Text(this.info.name)
        .fontSize(22)
        .maxLines(1)
        .fontWeight('bold')
        .width('100%')
        .padding({left:5,right:5})
        .margin({
          top:10,
          bottom:10
        })

      Button("点击导航")
        .margin({
          bottom:10
        })
        .onClick(()=>{
          this.click("导航",this.info.id)
        })
    }
    .shadow({
      radius: 5,
      color: '#DCDCDC',
      offsetX: 8,
      offsetY: 8
    })
    .width('100%')
    .backgroundColor('white')
    .margin({
      bottom:15
    })
    .onClick(()=>{
      this.click("详情",this.info.id);
    })
  }
}