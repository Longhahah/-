import * as hm from './ets'

const page = new hm.page();

@Component
export struct _img {
  @Prop img: string | Resource

  build() {
    Image(this.img)
      .width('100%').height(200).objectFit(ImageFit.Fill)
  }
}

@Component
export struct _title1 {
  @Prop text: string
  @Prop bk: boolean

  build() {
    Row() {
      Text(this.text).fontSize(25).fontWeight("bold")
        .borderWidth({ bottom: this.bk ? 3 : 0 })
        .padding({ bottom: this.bk ? 2 : 0 })
    }.width("100%").padding(20)
  }
}


class gezi {
  opacity: number = 1;
}

@Component
export struct _Donghua_gezi {
  @State arr: Array<Array<gezi>> = [[], [], [], [], []]
  @State opacitygz: number = 1;
  @State show: boolean = true;

  aboutToAppear(): void {
    let arr: Array<Array<gezi>> = [];
    for (let i = 0; i < 5; i++) {
      let z: Array<gezi> = [];
      for (let j = 0; j < 4; j++) {
        z.push(new gezi())
      }
      arr.push(z);
    }
    this.arr = arr;
    setTimeout(() => {
      this.show = false;
    }, 65 * 5 * 4 + 1000)
  }

  build() {
    if (this.show) {
      Column() {
        ForEach(this.arr, (item: Array<gezi>, index: number) => {
          Flex({ direction: index % 2 == 0 ? FlexDirection.Row : FlexDirection.RowReverse }) {
            ForEach(item, (item2: gezi, idx: number) => {
              _gezi({
                num: (index) * 4 + idx + 1
              })
            })
          }.height('20%').width('100%')
        })
      }
      .position({ x: 0, y: 0 })
      .width('100%').height('100%')
      .zIndex(1)
    }
  }
}


@Component
struct _gezi {
  @Prop num: number
  @State opa: number = 1;

  aboutToAppear(): void {
    setTimeout(() => {
      let t = setInterval(() => {
        this.opa = this.opa - 0.1;
        if (this.opa == 0) {
          clearInterval(t);
        }
      }, 30)
    }, this.num * 35)
  }

  build() {
    Column()
      .width('25%')
      .height('100%')
      .backgroundColor("white")
      .opacity(this.opa)
      .animation({ duration: 1000 })
  }
}


@Component
export struct _nav_back {
  @Prop text: string

  build() {
    Row({ space: 10 }) {
      Column() {
        Image($r('app.media.arr_back')).width(30).height(30).margin(10)
      }
      .width(50)
      .height(50)
      .borderRadius('50%')
      .backgroundColor("rgba(255,255,255,0.7)")
      .onClick(() => {
        page.back();
      })

      Text(this.text).fontSize(25)
    }.width('100%').padding({ left: 15 })
  }
}


@Component
export struct _nav {
  @Prop text: string

  build() {
    Row({ space: 10 }) {
      Text(this.text).fontSize(25)
    }.width('100%').padding({ left: 30, top: 30 })
  }
}


@Component
export struct img_card {
  @Prop img: string | Resource

  build() {
    Column() {
      Image(this.img)
        .width('92%')
        .height(150)
        .margin({ top: 15, bottom: 15 })
        .border({ radius: 15 })
        .shadow({
          radius: 20,
          offsetY: 25,
          offsetX: 0,
          color: "#bfbfbf"
        })
    }
  }
}


//
// @Component
// export struct _cardlist {
//   @State info : object = {}
//   click:()=>void
//   build(){
//     Stack({alignContent:Alignment.Bottom}){
//       Image(this.info.img).width('100%').height('100%')
//         .borderRadius(10)
//         .sharedTransition(this.info.id, {
//           duration: 800,
//           curve: Curve.Friction,
//           delay: 200
//         })
//       Row(){
//
//       }.backgroundColor('black')
//       .height(50)
//       .padding({left:10,right:10})
//       .width('100%')
//       .opacity(0.5)
//       .borderRadius(10)
//       Text(this.info.text).fontSize(26).fontColor('white')
//         .fontWeight('bold').width('100%')
//         .margin({left:10,bottom:10})
//     }.height(150)
//     .width('100%')
//     .shadow({
//       radius: 10,
//       color: '#DCDCDC',
//       offsetX: 8,
//       offsetY: 10
//     })
//     .margin({
//       bottom:10
//     })
//     .onClick(()=>{
//       this.click()
//     })
//   }
// }


//
// @Component
// export struct _danhang {
//   @State info : any = {}
//
//   click:()=>void
//   build(){
//     Row(){
//       Image(this.info.img ? this.info.img : (baseimg + this.info.img)).width(35).height(35)
//       Text(this.info.text).fontSize(25).margin({left:10})
//     }.width('94%')
//     .backgroundColor('white')
//     .height(60)
//     .shadow({
//       radius: 5,
//       color: '#DCDCDC',
//       offsetX: 8,
//       offsetY: 8
//     })
//     .margin({bottom:3})
//     .alignItems(VerticalAlign.Center)
//     .justifyContent(FlexAlign.Start)
//     .padding({left:10,right:10})
//     .onClick(()=>{
//       this.click();
//     })
//   }
// }


//
// @Component
// export struct _listzy {
//   @Link list : Array<object>;
//   private zuo : Array<object> = [];
//   private you : Array<object> = [];
//   click:(t)=>void;
//
//   aboutToAppear(){
//     let list = this.list ,zuo = [],you = [];
//     for(let i = 0 ; i < list.length ; i++){
//       if(i % 2 == 0){
//         zuo.push(list[i]);
//       }else{
//         you.push(list[i]);
//       }
//     }
//     this.zuo = zuo;
//     this.you = you;
//   }
//
//   build(){
//     Row(){
//       Column(){
//         ForEach(this.zuo,(item)=>{
//           zuoyouitem({
//             info:item,
//             click:(t)=>{
//               this.click(t)
//             }
//           })
//         })
//       }.width('46%')
//       Column(){
//         ForEach(this.you,(item)=>{
//           zuoyouitem({
//             info:item,
//             click:(t)=>{
//               this.click(t)
//             }
//           })
//         })
//       }.width('46%')
//     }
//     .width('100%')
//     .justifyContent(FlexAlign.SpaceAround)
//     .alignItems(VerticalAlign.Top)
//   }
// }
//
//
// @Component
// export struct zuoyouitem {
//   @State gaodu : number = 100;
//   @State info : any = {};
//   click:(t)=>void
//   build(){
//     Column(){
//       Image(this.info.img)
//         .width('100%')
//         .objectFit(ImageFit.Fill)
//         .onComplete((e)=>{
//           console.log("applog:img:"+this.info.img)
//           this.gaodu = (e.componentWidth * e.height) / e.width;
//         })
//         .height(this.gaodu+"px")
//       Text(this.info.biaoti)
//         .fontSize(22)
//         .maxLines(1)
//         .fontWeight('bold')
//         .width('100%')
//         .padding({left:5,right:5})
//         .margin({
//           top:10,
//           bottom:10
//         })
//       if(this.info.head && this.info.head != ""){
//         Row(){
//           Image(this.info.head.id ? this.info.head : (baseimg + this.info.head))
//             .width(30)
//             .height(30)
//             .borderRadius(15)
//             .margin({
//               left:5,
//               right:5
//             })
//           Text(this.info.name).fontSize(18)
//         }.alignItems(VerticalAlign.Center)
//         .justifyContent(FlexAlign.Start)
//         .margin({
//           top:10,
//           bottom:10
//         })
//         .width('100%')
//       }
//       if(this.info.youxia && this.info.youxia != ""){
//         Text(this.info.youxia).fontSize(24).fontWeight('bold').fontColor('red')
//           .width('100%')
//           .height(24)
//           .textAlign(TextAlign.End)
//           .margin({
//             right:5,
//             bottom:5
//           })
//       }
//     }
//     .shadow({
//       radius: 5,
//       color: '#DCDCDC',
//       offsetX: 8,
//       offsetY: 8
//     })
//     .width('100%')
//     .backgroundColor('white')
//     .margin({
//       bottom:15
//     })
//     .onClick(()=>{
//       this.click(this.info);
//     })
//   }
// }