/*
 * jQuery history plugin
 * 
 * The MIT License
 * 
 * Copyright (c) 2006-2009 Taku Sano (Mikage Sawatari)
 * Copyright (c) 2010 Takayuki Miwa
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
!function(t){function e(e){function s(t){return t===!0?function(t){return t}:"string"==typeof t&&(t=n(t.split("")))||"function"==typeof t?function(e){return t(encodeURIComponent(e))}:encodeURIComponent}function n(e){var i=new RegExp(t.map(e,encodeURIComponent).join("|"),"ig");return function(t){return t.replace(i,decodeURIComponent)}}e=t.extend({unescape:!1},e||{}),i.encoder=s(e.unescape)}var i={put:function(t,e){(e||window).location.hash=this.encoder(t)},get:function(e){var i=(e||window).location.hash.replace(/^#/,"");try{return t.browser.mozilla?i:decodeURIComponent(i)}catch(s){return i}},encoder:encodeURIComponent},s={id:"__jQuery_history",init:function(){var e='<iframe id="'+this.id+'" style="display:none" src="javascript:false;" />';return t("body").prepend(e),this},_document:function(){return t("#"+this.id)[0].contentWindow.document},put:function(t){var e=this._document();e.open(),e.close(),i.put(t,e)},get:function(){return i.get(this._document())}},n={};n.base={callback:void 0,type:void 0,check:function(){},load:function(){},init:function(t,i){e(i),r.callback=t,r._options=i,r._init()},_init:function(){},_options:{}},n.timer={_appState:void 0,_init:function(){var t=i.get();r._appState=t,r.callback(t),setInterval(r.check,100)},check:function(){var t=i.get();t!=r._appState&&(r._appState=t,r.callback(t))},load:function(t){t!=r._appState&&(i.put(t),r._appState=t,r.callback(t))}},n.iframeTimer={_appState:void 0,_init:function(){var t=i.get();r._appState=t,s.init().put(t),r.callback(t),setInterval(r.check,100)},check:function(){var t=s.get(),e=i.get();e!=t&&(e==r._appState?(r._appState=t,i.put(t),r.callback(t)):(r._appState=e,s.put(e),r.callback(e)))},load:function(t){t!=r._appState&&(i.put(t),s.put(t),r._appState=t,r.callback(t))}},n.hashchangeEvent={_init:function(){r.callback(i.get()),t(window).bind("hashchange",r.check)},check:function(){r.callback(i.get())},load:function(t){i.put(t)}};var r=t.extend({},n.base);r.type=t.browser.msie&&(t.browser.version<8||document.documentMode<8)?"iframeTimer":"onhashchange"in window?"hashchangeEvent":"timer",t.extend(r,n[r.type]),t.history=r}(jQuery);