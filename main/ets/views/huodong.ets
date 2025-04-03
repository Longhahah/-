import * as hm from '../ets'
import {Shuju,ResObject,baseimg} from '../http';
import * as ui from '../ui'
import _Huodong from '../model/huodong'
const s = new Shuju();
const page = new hm.page();

class _Hdback{
  code:number = 0;
  data:Array<_Huodong>=[];
}

class pgg{
  hid:string = ""
}

@Entry
@Component
export default struct Huodong{

  @State hdlist:Array<_Huodong> = [];

  aboutToAppear(): void {
    s.sb("huodong");
    s.se("order","id");
    s.g("c/common_list",{
      s:(d:_Hdback)=>{
        if(d.code == 200){
          this.hdlist = d.data;
        }
      }
    })
  }
  build(){
    Column(){
      ui._nav({text:"活动列表"})

      List({space:5}){
        ForEach(this.hdlist,(item:_Huodong)=>{
          ListItem(){
            _Rili({
              item:item,
              click:()=>{
                page.go("huodong_detail",{hid:item.id} as pgg)
              }
            })
          }.padding(10)
        })
      }
    }
    .height('100%')
    .width('100%')
    .backgroundColor("#F1F3F5")
  }
}



@Component
struct _Rili{
  item:_Huodong = new _Huodong();
  click:()=>void=()=>{}

  build(){
    Column({space:10}){
      Row(){
        Text(this.item.name).fontSize(27).fontWeight('bold')
      }.width('100%')
      Row({space:10}){
        Image($r('app.media.icon_rili')).width(30).height(30)
        Text(this.item.riqi)
      }.width('100%').alignItems(VerticalAlign.Center)
    }
    .borderRadius(10)
    .backgroundColor('white')
    .shadow({
      radius:20,
      offsetY:20,
      offsetX:0,
      color:"#e7e7e7"
    })
    .padding({left:15,right:15,top:20,bottom:20})
    .width('100%')
    .onClick(()=>{
      this.click();
    })
  }
}
