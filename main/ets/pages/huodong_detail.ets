import * as hm from '../ets'
import * as ui from '../ui'
import {Shuju,ResObject,baseimg} from '../http';
import _Huodong from '../model/huodong'

const page = new hm.page();
const s    = new Shuju();

let hid = "0";

class hdsj{
  code:number = 0;
  data:_Huodong = new _Huodong();
}

@Entry
@Component
struct Huodong_detail {

  @State hdinfo:_Huodong = new _Huodong();

  aboutToAppear(): void {
    hid = page.get("hid");
    // hid = "1";

    s.se("id",hid);
    s.sb("huodong");
    s.g("c/common_detail",{
      s:(d:hdsj)=>{
        if(d.code == 200){
          this.hdinfo = d.data;
        }
      }
    })
  }

  build() {
    Column() {
      if(this.hdinfo.name != ""){
        ui._nav_back({text:this.hdinfo.name})
        ui.img_card({img:baseimg + this.hdinfo.img})
      }

      Column({space:10}){
        Row(){
          Text("活动日期：").fontSize(20).fontWeight('bold')
          Text(this.hdinfo.riqi).fontSize(20)
        }.width('100%')
        Row(){
          Text("活动时间：").fontSize(20).fontWeight('bold')
          Text(this.hdinfo.shijian).fontSize(20)
        }.width('100%')
        Row(){
          Text("活动地点：").fontSize(20).fontWeight('bold')
          Text(this.hdinfo.didian).fontSize(20)
        }.width('100%')
        Row(){
          Text("活动介绍：").fontSize(20).fontWeight('bold')
          Text(this.hdinfo.jieshao).fontSize(20)
        }.width('100%')
      }.width('90%')
      .margin({top:30})
    }
    .height('100%')
    .width('100%')
    .backgroundColor("#f7f7f7")
  }
}