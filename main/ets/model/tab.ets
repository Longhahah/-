
export default class Tabitem{
  text:string = "";
  img:Resource=$r('app.media.logo')

  constructor(text:string,img:Resource) {
    this.text = text;
    this.img = img;
  }
}