import * as ui from '../ui'
import _Tongzhi from '../model/tongzhi'
import * as hm from '../ets'
import {Shuju,ResObject,baseimg} from '../http';
const s = new Shuju();
const page = new hm.page();




@Entry
@Component
struct Tongzhi_detail {

  @State tongzhi : _Tongzhi = new _Tongzhi("","","","");
  @State tid:string = ""

  aboutToAppear(): void {
    const tid = page.get("tid");
    this.tid = tid;
    s.sb("tongzhi");
    s.se("id",tid);
    s.g("c/common_detail",{
      s:(d:ResObject)=>{
        if(d.code == 200){
          let info = d.data;
          this.tongzhi = new _Tongzhi(info['biaoti'],info['neirong'],info['img'],info['addtime']);
        }
      }
    })
  }
  build() {
    Column(){
      Scroll(){
        Column(){
          if(this.tongzhi.img != ""){
            ui._nav_back({text:""})
            Row().height(10)
            Image(this.tongzhi.img)
              .width('100%').height(200).objectFit(ImageFit.Fill)
              .sharedTransition("a"+this.tid);
            Column({space:20}){
              Text(this.tongzhi.biaoti).fontSize(25).fontWeight('bold')
              Text(this.tongzhi.addtime).fontSize(20)
              Row(){
                Text(this.tongzhi.neirong).fontSize(20)
              }.width('100%').padding({ left:20,right:20 })
            }
            .width('100%')
            .margin({top:30})
            Row().height(100)
          }
        }
      }

    }
    .height('100%')
    .width('100%')
    .backgroundColor("#f7f7f7")
  }
}