import * as hm from '../ets';
import {Shuju,ResObject,baseimg} from '../http';
import * as ui from '../ui'
import * as modal from '../Component/CustomDialogs'
import _Fankui from '../model/fankui'

const mydata = new hm.mydata();
const page   = new hm.page();
const s      = new Shuju();


@Entry
@Component
struct Fankui {

  @State fankuis:Array<_Fankui>=[];

  _Getlist (){
    let id = mydata.get2("uid");
    s.sb("fankui");
    s.se('order','id');
    s.se("uid",id);
    s.se("tj","uid");
    s.g("c/common_list",{
      s:(d:ResObject)=>{
        if(d.code == 200){
          this.fankuis = d['data'] as Array<_Fankui>
        }
      }
    })
  }

  aboutToAppear (): void {
    this._Getlist();
  }

  build() {
    Column() {
      ui._nav_back({text:"用户反馈"})
      if(this.fankuis.length > 0){
        Row(){
          Text("*点击删除").fontColor(Color.Red).fontSize(20)
        }.width('100%').padding({left:15})
      }
      List(){
        ForEach(this.fankuis,(item:_Fankui,index:number)=>{
          ListItem(){
            Column({space:10}){
              Row(){
                Text("反馈内容："+item.neirong).fontSize(20)
              }.width('100%')
              Row(){
                Text("时间：" + item.addtime).fontSize(16)
              }.width('100%')
            }
            .width('100%')
            .padding(15)
            .backgroundColor(Color.White)
            .onClick(()=>{
              hm.tm("是否确认删除？",()=>{
                s.se("id",item.id);
                s.sb("fankui");
                s.g("c/common_delete",{
                  s:(d:ResObject)=>{
                    if(d.code == 200){
                      this.fankuis.splice(index,1);
                      hm.toast("删除成功");
                    }
                  }
                })
              })
            })
          }
        })
        if(this.fankuis.length == 0){
          ui._img({img:$r('app.media.none')})
        }
        ListItem().height(80)
      }
      .height('85%')
      .scrollBarWidth(0)
      .margin({top:"5%"})




      Image($r('app.media.fankui'))
        .width(60).height(60)
        .position({x:"100%",y:"100%"})
        .markAnchor({x:80,y:80})
        .onClick(()=>{
          let tc =new CustomDialogController({
            builder:modal.Dialog_Textarea({
              title:"请输入反馈意见",
              name:"意见",
              click:(value:string)=>{
                hm.tm("是否确认提交？",async ()=>{
                  let id = await mydata.get("uid");
                  s.se("uid",id);
                  s.se("neirong",value);
                  s.sb("fankui");
                  s.g("c/info_charu",{
                    s:(d:ResObject)=>{
                      if(d.code == 200){
                        hm.toast("提交成功");
                        this._Getlist();
                        tc.close();
                      }else{
                        hm.te("提交失败");
                      }
                    }
                  })
                })
              },
              close:()=>{
                tc.close();
              }
            }),
            alignment:DialogAlignment.Center
          })
          tc.open();
        })
    }
    .height('100%')
    .width('100%')
    .backgroundColor("#f7f7f7")
  }
}