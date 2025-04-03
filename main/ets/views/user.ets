import * as hm from '../ets';
import {Shuju,ResObject,baseimg} from '../http';
import * as ui from '../ui'
import * as modal from '../Component/CustomDialogs'

const mydata = new hm.mydata();
const page   = new hm.page();
const s      = new Shuju();

class plogin{

}

@Component
export default struct User {

  build() {
    Column() {
      ui._nav({text:"个人中心"})

      Column({space:5}){
        Row(){
          Text("用户反馈").fontSize(20)
        }
        .width('100%')
        .backgroundColor(Color.White)
        .padding(10)
        .shadow({
          radius: 5,
          color: '#DCDCDC',
          offsetX: 8,
          offsetY: 8
        })
        .onClick(()=>{
          page.go("Fankui");
        })

        Row(){
          Text("修改密码").fontSize(20)
        }
        .width('100%')
        .backgroundColor(Color.White)
        .padding(10)
        .shadow({
          radius: 5,
          color: '#DCDCDC',
          offsetX: 8,
          offsetY: 8
        })
        .onClick(()=>{
          let tc =new CustomDialogController({
            builder:modal.Dialog_Input({
              title:"请填写新密码",
              name:"密码",
              click:async (value:string)=>{
                let id = await mydata.get("uid");
                s.se("id",id);
                s.se("password",value);
                s.sb("user");
                s.g("c/info_xiugai",{
                  s:(d:ResObject)=>{
                    if(d.code == 200){
                      hm.toast("修改成功");
                      tc.close();
                    }else{
                      hm.te("修改失败");
                    }
                  }
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

        Row(){
          Text("退出登录").fontSize(20)
        }
        .width('100%')
        .backgroundColor(Color.White)
        .padding(10)
        .shadow({
          radius: 5,
          color: '#DCDCDC',
          offsetX: 8,
          offsetY: 8
        })
        .onClick(()=>{
          hm.tm("是否确认退出登录？",()=>{
            mydata.delete("uid").then(()=>{
              page.go("Login",{} as plogin,true);
            })
          })
        })

      }.width('90%')
      .margin({top:20})
    }
    .height('100%')
    .width('100%')
    .backgroundColor("#f7f7f7")
  }
}