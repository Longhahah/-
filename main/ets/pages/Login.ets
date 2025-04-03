import { curves } from '@kit.ArkUI';
import * as hm from '../ets'
import { Shuju,ResObject } from '../http'

const s = new Shuju();
const page  = new hm.page();
const mydata = new hm.mydata();

class user{
  username:string = "";
  password:string = "";
}
class pagego{
  uid:string = ""
}

@Entry
@Component
struct Login {

  @State y1:number = 0;
  @State op1:number = 0;
  @State User:user = {
    username:"",
    password:""
  }


  aboutToAppear(): void {
    let uid = mydata.get2("uid");
    if(uid != "null"){
      page.go("Index",{uid:uid} as pagego,true);
    }else{
      setTimeout(()=>{
        this.y1 = -50;
        this.op1 = 1;
      },100)
    }
  }

  build() {
    Column() {
      Column(){
        Image($r('app.media.logo')).width(100).height(100).margin({top:100})
        Text("校园智慧导航平台").fontSize(25).fontWeight('bold').margin({top:15})
        Column({space:20}){
          Column({space:10}){
            Row(){
              Text("账号").fontSize(20)
            }
            .width('100%')
            TextInput({placeholder:'请输入账号',text:this.User.username}).height(45)
              .onChange((v)=>{
                this.User.username = v;
              })
          }
          Column({space:10}){
            Row(){
              Text("密码").fontSize(20)
            }
            .width('100%')
            TextInput({placeholder:'请输入密码',text:this.User.password}).height(45)
              .type(InputType.Password)
              .onChange((v)=>{
                this.User.password = v;
              })
          }
          Button("登录/注册").width('100%')
            .onClick(()=>{
              if(this.User.password != "" && this.User.username !=""){
                s.sj(this.User);
                s.g("c/user_login_u",{
                  s:(d:ResObject)=>{
                    if(d.code == 200){
                      mydata.set("uid",d.data['id']).then(()=>{
                        hm.toast("登录成功",()=>{
                          page.go("Index",{uid:d.data['id']} as pagego,true);
                        })
                      })
                    }
                  }
                })
              }else{
                hm.toast("请输入完整");
              }
            })
        }
        .padding(20)
        .backgroundColor(Color.White)
        .borderRadius(20)
        .shadow({
          radius: 5,
          color: '#DCDCDC',
          offsetX: 8,
          offsetY: 8
        })
        .width('80%')
        .margin({top:30})
        Text("第一次登录视为注册").fontSize(15).fontColor(Color.Blue).margin({top:15})
      }
      .opacity(this.op1)
      .translate({y:this.y1})
      .animation({curve:curves.springMotion()})
      .margin({top:50})
    }
    .height('100%')
    .width('100%')
    .backgroundColor("#F1F3F5")
  }
}