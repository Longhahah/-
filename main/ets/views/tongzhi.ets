import * as ui from '../ui'
import _Tongzhi from '../model/tongzhi'
import * as hm from '../ets'
import {Shuju,ResObject,baseimg} from '../http';
const s = new Shuju();
const page = new hm.page();

class _Tzback{
  code:number = 0;
  data:Array<_Tongzhi> = [];
}
class tz{
  tid:string = ""
}
@Component
export default struct Tongzhi {

  @State tongzhi:Array<_Tongzhi>=[];

  _Getlist:()=>Promise<string>=()=>{
    return new Promise((succ,err)=>{
      s.sb("tongzhi");
      s.se("order","id");
      s.g("c/common_list",{
        s:(d:_Tzback)=>{
          if(d.code == 200){
            this.tongzhi = d.data;
          }
        }
      })
    })
  }

  aboutToAppear(): void {
    this._Getlist();
  }

  build() {
    Column(){
      ui._nav({text:"通知列表"})

      List({space:5}){
        ForEach(this.tongzhi,(item:_Tongzhi)=>{
          ListItem(){
            Row({space:10}){
              Image(baseimg + item.img).width('35%').height(90)
                .sharedTransition("a"+item.id, {
                  duration: 800,
                  curve: Curve.Friction,
                  delay: 200
                })
              Column(){
                Row(){
                  Text(item.biaoti).fontSize(24).fontWeight('bold')
                    .maxLines(1)
                    .textOverflow({overflow:TextOverflow.Ellipsis})
                }.width('100%')
                Blank();
                Row(){
                  Text(item.addtime.split(" ")[0]).fontSize(18)
                }.width('100%')
              }.height(90)
            }.width('100%').backgroundColor(Color.White)
            .padding({top:10,bottom:10})
            .onClick(()=>{
              page.go("tongzhi_detail",{tid:item.id} as tz)
            })
          }.width('98%').margin({left:'1%'})
        })
      }.height('90%')
      .scrollBarWidth(0)
      .margin({top:20})
    }
    .height('100%')
    .width('100%')
    .backgroundColor("#F1F3F5")

  }
}