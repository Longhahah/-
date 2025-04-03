import {baseimg} from '../http'

export default class _Jianzhu{
  name:string = "";
  dizhi:string = "";
  lat:number = 0;
  lng:number = 0;
  jianjie:string = "";
  img:string = "";
  id:string = "";
  markerid:string = ""

  constructor(lat:string,lng:string,img:string) {
    this.lat = parseFloat(lat);
    this.lng = parseFloat(lng);
    this.img = baseimg + img;
  }
}