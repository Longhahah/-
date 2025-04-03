import * as ui from '../ui'
import _Jianzhu from '../model/jianzhu'
import * as hm from '../ets'
import {Shuju,ResObject,baseimg} from '../http';
const s = new Shuju();
const page = new hm.page();
let jid = "0";

class _tupian{
  img:string = "";
  jieshao:string = "";
}

@Entry
@Component
struct Jianzhu_detail {

  @State info:_Jianzhu = new _Jianzhu("","","");
  @State imgs:Array<_tupian>=[];


  aboutToAppear(): void {
    jid = page.get("jid");
    s.se("id",jid);
    s.g("p/jianzhudetail",{
      s:(d:ResObject)=>{
        if(d.code == 200){
          this.info = d['data'] as _Jianzhu;
          this.imgs = d['tupian'];
        }
      }
    })
  }

  build() {
    Column(){
      ui._nav_back({text:"建筑详情"})

      Scroll(){
        Column(){
          Column({space:20}){
            Text(this.info.name).fontSize(20).fontWeight('bold')
            Row(){
              Text("地址："+this.info.dizhi).fontSize(18)
            }.width('100%')
            Row(){
              Text("简介："+this.info.jianjie).fontSize(18)
            }.width('100%')
          }.width('90%')
          .backgroundColor(Color.White)
          .borderRadius(20)
          .padding(15)
          .margin({top:20})

          Column({space:20}){
            ForEach(this.imgs,(item:_tupian)=>{
              Column(){
                Image(baseimg + item.img).width('100%')
                  .borderRadius({topLeft:20,topRight:20})
                Row(){
                  Text(item.jieshao).fontSize(18)
                }.width('90%')
                .margin({top:20})
              }
              .backgroundColor(Color.White)
              .borderRadius(20)
              .width('90%')
              .padding({bottom:20})

            })
          }.margin({top:20})
          Row().height(100)
        }
      }
      .scrollBarWidth(0)


    }
    .height('100%')
    .width('100%')
    .backgroundColor("#f7f7f7")
  }
}