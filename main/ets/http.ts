//这段代码主要实现了与后端接口进行交互的功能，定义了一些常量和类，用于构建请求 URL、处理响应数据
/**
 * 封装了与后端接口进行交互的功能，提供了发送请求、处理响应和管理请求数据的方法。
 * 通过 Shuju 类，可以方便地构建和发送 POST 请求，并处理请求结果。
 * 同时，定义了 ResObject 类用于表示响应对象，方便对响应数据进行处理。
 */
/**
 * 从 @kit.NetworkKit 模块导入 http 对象，用于进行网络请求
 */
import { http } from '@kit.NetworkKit';
/**
 * 从 @kit.BasicServicesKit 模块导入 BusinessError 类，用于处理网络请求中可能出现的错误
 */
import { BusinessError } from '@kit.BasicServicesKit';
/**
 * Houduan：指定后端使用的技术，这里设置为 "php"。
 *Genurl：定义后端服务的基础 URL。
 *baseimg：基于 Genurl 构建的图片资源的基础 URL，并将其导出，以便其他模块使用。
 */
const Houduan = "php";
const Genurl = "http://47.116.201.205/bs2025/0131/"
const baseimg = Genurl+"files/";

export{
  baseimg
}
/**
 * 用于表示从后端接口返回的响应对象。该类包含两个属性：
 *code：表示响应的状态码，类型为 number。
 *data：表示响应的数据，类型可以是对象数组、字符串或单个对象
 */
export class ResObject{
  code:number;
  data:Array<object> | string | object;
}
/**
 * 定义了一个 Shuju 类，用于处理与后端接口的交互。
 * 该类包含一个私有属性 shuju，用于存储请求数据
 */
export class Shuju {
  private shuju = {};
  /**
   * 该方法用于发送 POST 请求到后端接口。
   *接收两个参数：
   *api：接口的路径，格式为 module/method。
   *callback：回调函数对象，包含 s 或 success 用于处理成功响应，e 或 error 用于处理错误响应。
   *根据 Houduan 的值构建请求 URL。
   *设置请求头为 application/json，并将 shuju 对象作为请求体发送。
   *处理请求成功和失败的情况，并在控制台输出相关日志
   */
  g = function (api, callback) {
    let succ = callback['s'] || callback['success'];
    let error = callback['e'] || callback['error'];
    this.shuju.method = api.split('/')[1];
    let httpRequest = http.createHttp();
    httpRequest.request(
      Houduan == "php" ? (Genurl + "php/" + api.split('/')[0] + '.php') : (Genurl + api.split('/')[0]),
      {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json'
        },
        extraData: this.shuju,
        usingCache: true, // 可选，默认为true
        connectTimeout: 60000, // 可选，默认为60000ms
        readTimeout: 60000, // 可选，默认为60000ms
      }, (err: BusinessError, data: http.HttpResponse) => {
      if (!err) {
        console.info('applog------------------------------------');
        console.info('applog:' + JSON.stringify(this.shuju));
        console.info('applog:' + api);
        console.info('applog------------------------------------');
        console.info('applog------------------------------------');
        console.info('applog' + api.split('/')[1] + ":" + JSON.stringify(data.result));
        console.info('applog------------------------------------');
        console.info('applog------------------------------------');

        this.shuju = {};
        httpRequest.destroy();
        //@ts-ignore
        succ(JSON.parse(data.result));
      } else {
        console.error('applog:error:' + JSON.stringify(err));
        httpRequest.off('headersReceive');
        httpRequest.destroy();
        error();
      }
    }
    );
  };
/**
 * 该方法用于发送自定义的 POST 请求。
 *接收两个参数：
 *url：请求的 URL。
 *data：请求体数据。
 *返回一个 Promise 对象，处理请求成功和失败的情况
 */
  justhttp = function(url,data){
    return new Promise((succ,error)=>{
      let httpRequest = http.createHttp();
      httpRequest.request(
        url,
        {
          method: http.RequestMethod.POST,
          // 开发者根据自身业务需要添加header字段
          header: {
            'Content-Type': 'application/json'
          },
          // 当使用POST请求时此字段用于传递请求体内容，具体格式与服务端协商确定
          extraData: data,
          usingCache: true, // 可选，默认为true
          connectTimeout: 60000, // 可选，默认为60000ms
          readTimeout: 60000, // 可选，默认为60000ms
        }, (err: BusinessError, data: http.HttpResponse) => {
        if (!err) {

          httpRequest.destroy();
          //           @ts-ignore
          succ(JSON.parse(data.result));
        } else {
          console.error('applog:error:' + JSON.stringify(err));
          httpRequest.off('headersReceive');
          httpRequest.destroy();
          error(JSON.stringify(err));
        }
      }
      );
    })
  };
/**
 * 该方法用于合并 json 对象到 shuju 对象中
 */
  sj = function(json){
    this.shuju = {...this.shuju,...json};
  }
/**
 * 该方法用于设置 shuju 对象中指定属性的值
 */
  se = function(name,value){
    this.shuju[name] = value;
  }
/*
 *该方法用于设置 shuju 对象中 biao 属性的值
 */
  sb = function(b){
    this.shuju["biao"] = b;
  }

}

