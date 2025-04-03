
//底部多个选项直接显示的
@CustomDialog
export struct Dialog1 {
  private  arrs:Array<string>=[]
  private title?: string = "请选择"
  click?:(idx:number)=>void
  close?:()=>void
  controller: CustomDialogController = new CustomDialogController({
    builder: Dialog1({}),
  })
  build() {
    Column() {
      Row(){
        Text(this.title).fontSize(25).fontWeight('bold')
      }.width('100%').margin({top:20}).padding({left:20})
      ForEach(this.arrs,(item:string,idx)=>{
        Text(item)
          .fontSize(20)
          .margin({ top: 10, bottom: 10 })
          .onClick(()=>{
            if(this.click){
              this.click(idx)
            }
            // this.controller.close();
          })
      })
    }
  }
}


//底部多个选项picker形式显示的
@CustomDialog
export struct Dialog_Picker {
  private arrs:Array<string>=[]
  private select?: number | number[] = 1
  private title?: string = "请选择"
  click?:(idx:number | number[])=>void
  controller: CustomDialogController = new CustomDialogController({
    builder: Dialog_Picker({}),
  })
  build() {
    Column() {
      Row(){
        Text(this.title).fontSize(25).fontWeight('bold')
      }.width('100%').margin({top:20}).padding({left:20})
      TextPicker({ range: this.arrs, selected: this.select })
        .onChange((value: string | string[], index: number | number[]) => {
          this.select = index;
          console.info('Picker item changed, value: ' + value + ', index: ' + index)
        })
      // .textStyle({color: Color.Black, font: {size: 20, weight: FontWeight.Normal}})
      // .selectedTextStyle({color: Color.Blue, font: {size: 30, weight: FontWeight.Bolder}})
      // .gradientHeight(100)
      Row(){
        Button("确定").width('40%')
          .onClick(()=>{
            if(this.click){
              if(typeof this.select === 'number'){
                this.click(this.select);
              }
            }
            this.controller.close();
          })
        Button("取消").width('40%').backgroundColor('red')
          .onClick(()=>{
            this.controller.close();
          })
      }.width('100%').justifyContent(FlexAlign.SpaceAround)
      .margin({bottom:20})
    }
  }
}

//单个输入框的
@CustomDialog
export struct Dialog_Input {
  private value?: string = "";
  private name?: string = "值1";
  private title?: string = "标题"
  click?:(idx:string)=>void
  close?:()=>void
  controller: CustomDialogController = new CustomDialogController({
    builder: Dialog_Input(),
  })


  build() {
    Column() {
      Row(){
        Text(this.title).fontSize(25).fontWeight('bold')
      }.width('100%').margin({top:20}).padding({left:20})

      Row(){
        Text(this.name).fontSize(20)
        TextInput({text:this.value}).width('60%').fontSize(20).height(40)
          .onChange((v)=>{
            this.value = v;
          })
      }.padding(20).justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row(){
        Button("确定").width('40%')
          .onClick(()=>{
            if(this.value == "")return;
            if(this.value && this.click){
              this.click(this.value);
            }
            if(this.controller){
              this.controller.close();
            }
          })
        Button("取消").width('40%').backgroundColor('red')
          .onClick(()=>{
            if(this.close){
              this.close();
            }
            if(this.controller){
              this.controller.close();
            }
          })
      }.width('100%').justifyContent(FlexAlign.SpaceAround)
      .margin({bottom:20})
    }
  }
}



//单个输入框的
@CustomDialog
export struct Dialog_Textarea {
  private value?: string = "";
  private name?: string = "值1";
  private title?: string = "标题"
  click?:(idx:string)=>void
  close?:()=>void
  controller: CustomDialogController = new CustomDialogController({
    builder: Dialog_Textarea(),
  })


  build() {
    Column() {
      Row(){
        Text(this.title).fontSize(25).fontWeight('bold')
      }.width('100%').margin({top:20}).padding({left:20})

      Row(){
        Text(this.name).fontSize(20)
        TextArea({text:this.value}).width('60%').fontSize(20).height(100)
          .onChange((v)=>{
            this.value = v;
          })
      }.padding(20).justifyContent(FlexAlign.SpaceBetween)
      .width('100%')

      Row(){
        Button("确定").width('40%')
          .onClick(()=>{
            if(this.value == "")return;
            if(this.value && this.click){
              this.click(this.value);
            }
            if(this.controller){
              this.controller.close();
            }
          })
        Button("取消").width('40%').backgroundColor('red')
          .onClick(()=>{
            if(this.close){
              this.close();
            }
            if(this.controller){
              this.controller.close();
            }
          })
      }.width('100%').justifyContent(FlexAlign.SpaceAround)
      .margin({bottom:20})
    }
  }
}


@CustomDialog
export struct Dialogriqi {
  private value?: string = "2020-01-01";
  private title?: string = "标题"
  private start?: string = "1970-1-1";
  private end  ?: string = "2100-1-1";
  click?:(idx:string)=>void
  close?:()=>void
  controller: CustomDialogController = new CustomDialogController({
    builder: Dialogriqi({}),
  })
  build() {
    Column() {
      Row(){
        Text(this.title).fontSize(25).fontWeight('bold')
      }.width('100%').margin({top:20}).padding({left:20})

      DatePicker({
        start: new Date(this.start),
        end: new Date(this.end),
        selected: new Date(this.value)
      })
        .onDateChange((v) => {
          const date = new Date(v);
          // 使用toISOString方法获取ISO格式的日期字符串，并截取前10个字符
          this.value = date.toISOString().slice(0, 10);
        })

      Row(){
        Button("确定").width('40%')
          .onClick(()=>{
            if(this.value && this.click){
              this.click(this.value.toString());
            }
            if(this.controller){
              this.controller.close();
            }
          })
        Button("取消").width('40%').backgroundColor('red')
          .onClick(()=>{
            if(this.close){
              this.close();
            }
            if(this.controller){
              this.controller.close();
            }
          })
      }.width('100%').justifyContent(FlexAlign.SpaceAround)
      .margin({bottom:20})
    }
  }
}

export class Value{
  name:string
  value:string|number
  label:string

  constructor(label:string,name:string,value:string|number) {
    this.name = name;
    this.value=value;
    this.label=label;
  }
}
