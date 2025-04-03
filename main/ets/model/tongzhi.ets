import {baseimg} from '../http'

export default class _Tongzhi{
  biaoti:string = "";
  neirong:string = "";
  img:string = "";
  addtime:string = "";
  id:string = ""

  constructor(biaoti:string,neirong:string,img:string,addtime:string) {
    this.biaoti = biaoti;
    this.neirong = neirong;
    this.img = baseimg + img;
    this.addtime = addtime.split(" ")[0];
  }
}