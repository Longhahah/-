import {baseimg} from '../http'
import _Jianzhu  from './jianzhu'

export default class _Quyu{
  name:string = "";
  lat:number = 0;
  lng:number = 0;
  img:string = "";
  jianzhu:Array<_Jianzhu>=[]

  constructor(lat:string,lng:string,img:string) {
    this.lat = parseFloat(lat);
    this.lng = parseFloat(lng);
    this.img = baseimg + img;
  }
}