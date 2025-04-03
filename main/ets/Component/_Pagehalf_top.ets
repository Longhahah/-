import * as hm from '../ets'
import {Shuju,ResObject,baseimg} from '../http';
import _Pagehalf from '../Component/_Pagehalf'
const page = new hm.page();
const s = new Shuju();


class pagesousuo{
  keyword:string = ""
}
@Entry
@Component
export default  struct _Pagehalf_top {

  @State keyword:string = "";
  sousuo:(lat:number,lng:number)=>void=()=>{}

  build() {
    Column() {
      //最上面的
      Row(){
        Row(){
          Image($r('app.media.sousuo')).width(30).height(30)
            .onClick(()=>{
              s.se("tj","name");
              s.se("name",this.keyword);
              s.sb("jianzhu");
              s.g("c/common_detail",{
                s:(d:ResObject)=>{
                  if(d.code == 200){
                    this.sousuo(parseFloat(d['data']['lat']),parseFloat(d['data']['lng']));
                  }else{
                    hm.toast("没有这个建筑");
                  }
                }
              })
              this.keyword = "";
            })
          Blank()
          TextInput({placeholder:"请输入建筑名称",text:this.keyword}).width(300)
            .onChange((v)=>{
              this.keyword = v;
            })
        }.backgroundColor(Color.White)
        .padding(5).borderRadius(10)
        .width('100%')

        // Blank()
        // Image($r('app.media.tongzhi')).width(30).height(30).margin({right:20})
        //   .onClick(()=>{
        //     page.go("tongzhi")
        //   })
        // Image($r('app.media.geren')).width(30).height(30)
        //   .onClick(()=>{
        //     page.go("User");
        //   })
      }.width("100%")
      .padding(10)
      .backgroundColor(Color.White)


    }
    .width('100%')
    .position({x:0,y:10})
    .zIndex(100)
  }
}

