bplist00���X$versionX$objectsY$archiverT$top ���9/56<=>hijklmnopqrstuvwxyz{|}~�����������������������U$null�	
V$classR$0__NSURLResponseTypeR$1_%_CFCachedURLResponseReceiverDataArray__NSDictionaryType[_NSDataType�8� �3� � �	 
!"#$%&'()*+,-.R$6S$10R$2R$7R$3S$11R$8R$4R$9R$5�	�	��/�2��0��0	134WNS.base[NS.relative� ��_Lhttps://platform.twitter.com/js/timeline.13218e1ae07c822bbf435af1a8437856.js�789:Z$classnameX$classesUNSURL�9;XNSObject#A�y��S�I��?@	ATgWNS.keysZNS.objects�BCDEFGHIJKLMNOPQRS�
������������������UVWXYZ[\]^_`abcdef����� �!�"�#�$�%�&�'�(�)�*�+�,�-�.\Content-Type[X-Served-ByWX-CacheTVarySAgeSViaVServer_Content-EncodingSP3PZKeep-Alive]Cache-ControlTDate^Content-LengthWX-TimerZConnection]Accept-RangesTEtag]Last-Modified_%application/javascript; charset=utf-8_cache-tw-ams1-cr1-9-TWAMS1SHIT_Accept-Encoding,HostV174931[1.1 varnishVApacheTgzip_TCP="CAO DSP LAW CURa ADMa DEVa TAIa PSAa PSDa IVAa IVDa OUR BUS IND UNI COM NAV INT"_timeout=7, max=50_public, max-age=315569260_Sun, 21 Feb 2016 08:37:55 GMTU10656_S1456043875.340863,VS0,VE0ZKeep-AliveUbytes_'"458ea0eb4051f623a3fd6f39546c94a9+gzip"_Fri, 19 Feb 2016 07:15:58 GMT�78��\NSDictionary��;\NSDictionary�&�	���YNS.string�1_application/javascript�78��_NSMutableString���;_NSMutableStringXNSString�78��_NSHTTPURLResponse���;_NSHTTPURLResponse]NSURLResponse�@	������4�6�7ҥ	��WNS.dataOcd__twttrll([5],{157:function(e,t,i){var r=i(79);e.exports=r.build([i(158),i(165),i(132),i(135),i(137),i(119),i(166),i(167),i(121),i(122),i(115),i(170),i(171),i(173),i(174),i(175),i(178),i(180),i(181),i(182),i(131),i(183),i(185),i(123),i(124),i(138),i(187)],{pageForAudienceImpression:"timeline",productName:"embeddedtimeline",breakpoints:{320:"env-wide"}})},158:function(e,t,i){function r(e){e.params({widgetId:{required:!0},instanceId:{required:!0,fallback:u.deterministic},lang:{required:!0,transform:b.matchLanguage,fallback:"en"},width:{required:!0,fallback:"520px",validate:g,transform:g},height:{validate:g,transform:g},theme:{fallback:[m(l.val,l,"widgets:theme")],validate:y},tweetLimit:{transform:c.asInt},partner:{fallback:m(l.val,l,"partner")},previewParams:{},profileScreenName:{},profileUserId:{},profileShowReplies:{fallback:!1,transform:c.asBoolean},favoritesScreenName:{},favoritesUserId:{},listOwnerScreenName:{},listOwnerUserId:{},listId:{},listSlug:{},customTimelineId:{}}),e.selectors({header:".timeline-header, .timeline-Header",footer:".timeline-footer, .timeline-Footer",viewport:".stream, .timeline-Viewport",tweetList:".h-feed, .timeline-TweetList",tweetsInStream:".h-feed .tweet, .timeline-Tweet"}),e.around("scribeNamespace",function(e){return h.aug(e(),{page:"timeline"})}),e.around("scribeData",function(e){return h.aug(e(),{widget_id:this.params.widgetId,message:this.params.partner,query:this.el&&this.el.getAttribute("data-search-query"),profile_id:this.el&&this.el.getAttribute("data-profile-id")})}),e.around("widgetDataAttributes",function(e){return h.aug({"widget-id":this.params.widgetId,"user-id":this.el&&this.el.getAttribute("data-profile-id"),"search-query":this.el&&this.el.getAttribute("data-search-query")},e())}),e.define("updateViewportHeight",function(){var e,t=this.sandbox,i=this.selectOne("header"),r=this.selectOne("footer"),n=this.selectOne("viewport");return o.read(function(){e=t.height-2*k,e-=i?i.offsetHeight:0,e-=r?r.offsetHeight:0}),o.write(function(){n.style.height=e+"px"})}),e.define("adjustWidgetSize",function(){return this.isStaticTimeline?this.sandbox.matchHeightToContent():this.updateViewportHeight()}),e.define("reconfigureWithServerSideParams",function(e){e=e||{},this.params.linkColor=this.params.linkColor||e.linkColor,this.params.theme=this.params.theme||e.theme||"light",this.params.height=g(this.params.height||e.height||"600px")}),e.define("scribeImpressionsForInitialTweetSet",function(e){var t=p(this.select("tweetsInStream")),i=Object.keys(t),r=i.length?"results":"no_results",n=this.el.getAttribute("data-collection-id");n&&(i.push(n),t[n]={item_type:I.CUSTOM_TIMELINE}),this.scribe({component:"timeline",element:"initial",action:r},{widget_in_viewport:e,item_ids:i,item_details:t})}),e.override("initialize",function(){this.isStaticTimeline=this.params.tweetLimit&&this.params.tweetLimit>0,this.isPreviewTimeline=!!this.params.previewParams}),e.override("hydrate",function(){var e=this,t=this.isPreviewTimeline?w.preview(this.params.previewParams):w.timeline(this.params);return t.then(function(t){e.html=t.html,e.reconfigureWithServerSideParams(t.config),x(e,t,C.INITIAL)})}),e.override("render",function(){var e,t=this;return this.el=this.sandbox.htmlToElement(this.html),this.el?(this.el.lang=this.params.lang,this.usingRefreshHtml=s.present(this.el,"timeline-Widget"),"dark"==this.params.theme&&s.add(this.el,"thm-dark"),this.isStaticTimeline&&(this.sandbox.addRootClass("var-static"),v(this.selectOne("tweetList"),this.params.tweetLimit)),e=this.usingRefreshHtml?a.timeline(this.params.lang,this.params.theme):a.timelineLegacy(),n.all([this.sandbox.appendStyleSheet(e),this.sandbox.styleSelf({display:"inline-block",maxWidth:E,width:this.params.width,minWidth:T,marginTop:0,marginBottom:0})]).then(function(){return t.prepForInsertion(t.el),t.sandbox.injectWidgetEl(t.el)})):n.reject(new Error("unable to render"))}),e.override("show",function(){var e=this.sandbox,t=this;return this.sandbox.makeVisible().then(function(){return e.styleSelf({minHeight:t.isStaticTimeline?void 0:P,height:t.params.height})}).then(function(){return t.adjustWidgetSize()}).then(function(){return o.read(function(){var i=d(e.sandboxEl);t.scribeImpressionsForInitialTweetSet(i)})})}),e.last("resize",function(){return this.adjustWidgetSize()})}var n=i(2),a=i(105),s=i(24),o=i(46),l=i(16),d=i(114),c=i(15),u=i(31),h=i(14),f=i(79),m=i(20),p=i(111),g=i(113),v=i(159),w=i(160),b=i(87),y=i(162),x=i(163),I=i(112),C=i(164),T="180px",E="100%",P="200px",k=1;e.exports=f.couple(i(90),i(91),r)},159:function(e,t){function i(e,t){var i;if(e)for(;i=e.children[t];)e.removeChild(i)}e.exports=i},160:function(e,t,i){function r(e){return P+e}function n(e){return k+e}function a(e){return"tl_"+e.widgetId+"_"+e.instanceId}function s(e){var t=e.sinceId||e.maxId||e.maxPosition||e.minPosition;return"tlPoll_"+e.widgetId+"_"+e.instanceId+"_"+t}function o(e){if(!e||!e.headers)throw new Error("unexpected response schema");return{html:e.body,config:e.config,pollInterval:1e3*parseInt(e.headers.xPolling,10)||null,maxCursorPosition:e.headers.maxPosition,minCursorPosition:e.headers.minPosition}}function l(e){if(e&&e.headers)throw new Error(e.headers.status);throw e instanceof Error?e:new Error(e)}function d(e){var t=r(e.widgetId),i=a(e),n=b.asBoolean(g.val("widgets:new-timeline-design"))||p.hash.indexOf("_TWREFRESH_")>-1,s={lang:e.lang,t:I(),domain:p.host,tweet_limit:e.tweetLimit,dnt:w.enabled(),new_html:n},d=y.aug(s,x(e));return d=y.compact(d),f.fetch(t,d,m,i).then(o,l)}function c(e){var t=n(e.widgetId),i=s(e),r=y.compact({lang:e.lang,since_id:e.sinceId,max_id:e.maxId,min_position:e.minPosition,max_position:e.maxPosition,domain:p.host,dnt:w.enabled(),new_html:e.new_html}),a=y.aug(r,x(e));return a=y.compact(a),f.fetch(t,a,m,i).then(o,l)}function u(e){return e.new_html=!0,c(e)}function h(e){return f.fetch(S,e,m).then(o,l)}var f=i(108),m=i(109),p=i(13),g=i(16),v=i(17),w=i(36),b=i(15),y=i(14),x=i(161),I=i(110),C="https://cdn.syndication.twimg.com/widgets/timelines/",T="https://syndication.twitter.com/widgets/timelines/paged/",E="https://syndication.twitter.com/widgets/timelines/preview/",P=v.get("endpoints.timeline")||C,k=v.get("endpoints.timelinePoll")||T,S=v.get("endpoints.timelinePreview")||E;e.exports={timeline:d,poll:c,pollRefresh:u,preview:h}},161:function(e,t){function i(e){var t={};return e=e||{},e.profileScreenName||e.profileUserId?t={override_type:"user",override_id:e.profileUserId,override_name:e.profileScreenName,with_replies:e.profileShowReplies?"true":"false"}:e.favoritesScreenName||e.favoritesUserId?t={override_type:"favorites",override_id:e.favoritesUserId,override_name:e.favoritesScreenName}:e.listOwnerScreenName||e.listOwnerUserId||e.listId||e.listSlug?t={override_type:"list",override_owner_id:e.listOwnerUserId,override_owner_name:e.listOwnerScreenName,override_id:e.listId,override_name:e.listSlug}:e.customTimelineId&&(t={override_type:"custom",override_id:e.customTimelineId}),t}e.exports=i},162:function(e,t){function i(e){return r.test(e)}var r=/^(dark|light)$/;e.exports=i},163:function(e,t,i){function r(e,t,i){switch(e.cursors=e.cursors||{},e.pollInterval=t.pollInterval,i){case n.INITIAL:e.cursors.min=t.minCursorPosition,e.cursors.max=t.maxCursorPosition;break;case n.NEWER:e.cursors.max=t.maxCursorPosition||e.cursors.max;break;case n.OLDER:e.cursors.min=t.minCursorPosition||e.cursors.min}}var n=i(164);e.exports=r},164:function(e,t){e.exports={INITIAL:1,NEWER:2,OLDER:3}},165:function(e,t,i){function r(e){e.params({chrome:{transform:a,fallback:""}}),e.selectors({streamContainer:".stream, .timeline-Viewport",tweetStream:".h-feed, .timeline-TweetList"}),e.before("render",function(){this.params.chrome.transparent&&this.sandbox.addRootClass("var-chromeless"),this.params.chrome.hideBorder&&this.sandbox.addRootClass("var-borderless"),this.params.chrome.hideHeader&&this.sandbox.addRootClass("var-headerless"),this.params.chrome.hideFooter&&this.sandbox.addRootClass("var-footerless")}),e.after("render",function(){return this.params.chrome.hideScrollBar?this.hideScrollBar():void 0}),e.after("resize",function(){return this.params.chrome.hideScrollBar?this.hideScrollBar():void 0}),e.define("hideScrollBar",function(){var e=this.selectOne("streamContainer"),t=this.selectOne("tweetStream");return n.defer(function(){var i,r;e.style.width="",i=e.offsetWidth-t.offsetWidth,r=e.offsetWidth+i,e.style.width=r+"px"})})}var n=i(46),a=i(141);e.exports=r},166:function(e,t){function i(e){e.params({ariaLive:{fallback:""}}),e.selectors({newTweetsNotifier:".new-tweets-bar"}),e.after("render",function(){var e=this.selectOne("newTweetsNotifier");"assertive"===this.params.ariaLive&&e&&e.setAttribute("aria-live","assertive")})}e.exports=i},167:function(e,t,i){function r(e){e.selectors({fullTimestampToLocalize:".long-permalink time",relativeTimestampToLocalize:".permalink time"}),e.after("prepForInsertion",function(e){var t=o(this.el);t&&(this.select(e,"fullTimestampToLocalize").forEach(function(e){var i=e.getAttribute("datetime"),r=i&&t.localTimeStamp(i);r&&(e.innerHTML=r)}),this.select(e,"relativeTimestampToLocalize").forEach(function(e){var i=e.getAttribute("datetime"),r=i&&t.timeAgo(i);r&&(e.innerHTML=r)}))}),e.define("updateRelativeTimestamps",function(){var e=o(this.el);if(e){var t=this.select("relativeTimestampToLocalize").reduce(function(t,i){var r=i.getAttribute("datetime"),n=r&&e.timeAgo(r);return n&&t.push(function(){i.innerHTML=n}),t},[]);return n.all(t.map(a.write))}}),e.after("render",function(){var e=this;s.setInterval(function(){e.updateRelativeTimestamps()},l)})}var n=i(2),a=i(46),s=i(7),o=i(168),l=6e4;e.exports=r},168:function(e,t,i){function r(e){return new a(n.compact({months:(e.getAttribute("data-dt-months")||"").split("|"),phrases:{AM:e.getAttribute("data-dt-am"),PM:e.getAttribute("data-dt-pm"),now:e.getAttribute("data-dt-now"),s:e.getAttribute("data-dt-s"),m:e.getAttribute("data-dt-m"),h:e.getAttribute("data-dt-h"),second:e.getAttribute("data-dt-second"),seconds:e.getAttribute("data-dt-seconds"),minute:e.getAttribute("data-dt-minute"),minutes:e.getAttribute("data-dt-minutes"),hour:e.getAttribute("data-dt-hour"),hours:e.getAttribute("data-dt-hours")},formats:{full:e.getAttribute("data-dt-full"),abbr:e.getAttribute("data-dt-abbr"),shortdate:e.getAttribute("data-dt-short"),longdate:e.getAttribute("data-dt-long")}}))}var n=i(14),a=i(169);e.exports=r},169:function(e,t){function i(e){return 10>e?"0"+e:e}function r(e){function t(e,t){return n&&n[e]&&(e=n[e]),e.replace(/%\{([\w_]+)\}/g,function(e,i){return void 0!==t[i]?t[i]:e})}var n=e&&e.phrases,a=e&&e.months||o,s=e&&e.formats||l;this.timeAgo=function(e){var i,n=r.parseDate(e),o=+new Date,l=o-n;return n?isNaN(l)||2*d>l?t("now"):c>l?(i=Math.floor(l/d),t(s.abbr,{number:i,symbol:t(f,{abbr:t("s"),expanded:t(i>1?"seconds":"second")})})):u>l?(i=Math.floor(l/c),t(s.abbr,{number:i,symbol:t(f,{abbr:t("m"),expanded:t(i>1?"minutes":"minute")})})):h>l?(i=Math.floor(l/u),t(s.abbr,{number:i,symbol:t(f,{abbr:t("h"),expanded:t(i>1?"hours":"hour")})})):365*h>l?t(s.shortdate,{day:n.getDate(),month:t(a[n.getMonth()])}):t(s.longdate,{day:n.getDate(),month:t(a[n.getMonth()]),year:n.getFullYear().toString().slice(2)}):""},this.localTimeStamp=function(e){var n=r.parseDate(e),o=n&&n.getHours();return n?t(s.full,{day:n.getDate(),month:t(a[n.getMonth()]),year:n.getFullYear(),hours24:i(o),hours12:13>o?o?o:"12":o-12,minutes:i(n.getMinutes()),seconds:i(n.getSeconds()),amPm:t(12>o?"AM":"PM")}):""}}var n=/(\d{4})-?(\d{2})-?(\d{2})T(\d{2}):?(\d{2}):?(\d{2})(Z|[\+\-]\d{2}:?\d{2})/,a=/[a-z]{3,4} ([a-z]{3}) (\d{1,2}) (\d{1,2}):(\d{2}):(\d{2}) ([\+\-]\d{2}:?\d{2}) (\d{4})/i,s=/^\d+$/,o=["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"],l={abbr:"%{number}%{symbol}",shortdate:"%{day} %{month}",longdate:"%{day} %{month} %{year}",full:"%{hours12}:%{minutes} %{amPm} - %{day} %{month} %{year}"},d=1e3,c=60*d,u=60*c,h=24*u,f='<abbr title="%{expanded}">%{abbr}</abbr>';r.parseDate=function(e){var t,i,r=e||"",l=r.toString();return(t=function(){var e;return s.test(l)?parseInt(l,10):(e=l.match(a))?Date.UTC(e[7],o.indexOf(e[1]),e[2],e[3],e[4],e[5]):(e=l.match(n))?Date.UTC(e[1],e[2]-1,e[3],e[4],e[5],e[6]):void 0}())?(i=new Date(t),!isNaN(i.getTime())&&i):!1},e.exports=r},170:function(e,t,i){function r(e){e.selectors({followButton:".follow-button"}),e.define("handleFollowButtonClick",function(e,t){var i=a.intentForFollowURL(t.href),r=s.asBoolean(t.getAttribute("data-age-gate"));r||n.open(i,this.sandbox.sandboxEl,e)}),e.after("render",function(){this.on("click","followButton",function(e,t){this.handleFollowButtonClick(e,t)})})}var n=i(26),a=i(27),s=i(15);e.exports=r},171:function(e,t,i){function r(e){e.selectors({gifPlayer:".GifPlayer, .MediaPlayer",gifPlayerVideo:".GifPlayer-video, .MediaPlayer-video",gifPlayerPlayButton:".GifPlayer-playButton, .MediaPlayer-playButton"}),e.after("prepForInsertion",function(e){var t=this;this.select(e,"gifPlayer").forEach(function(e){new n({rootEl:e,videoEl:t.selectOne(e,"gifPlayerVideo"),playButtonEl:t.selectOne(e,"gifPlayerPlayButton"),fallbackUrl:e.getAttribute("data-fallback-url")})})})}var n=i(172);e.exports=r},172:function(e,t,i){function r(e){e=n.parse(e),this.rootEl=e.rootEl,this.videoEl=e.videoEl,this.playButtonEl=e.playButtonEl,this.fallbackUrl=e.fallbackUrl,this.player=new d({videoEl:this.videoEl,loop:!0,autoplay:!1}),this._attachClickListener()}var n,a=i(24),s=i(23),o=i(130),l=i(30),d=i(128);n=(new l).require("rootEl","videoEl","playButtonEl").defaults({fallbackUrl:null}),r.prototype._attachClickListener=function(){function e(e){s.stopPropagation(e),t._togglePlayer()}var t=this;this.videoEl.addEventListener("click",e,!1),this.playButtonEl.addEventListener("click",e,!1)},r.prototype._togglePlayer=function(){return this.player.hasPlayableSource()?(this.player.toggle(),void a.toggle(this.rootEl,"is-playing",!this.player.isPaused())):void(this.fallbackUrl&&o(this.fallbackUrl))},e.exports=r},173:function(e,t,i){function r(e){for(var t="",i=Math.floor(e/u),r=i;r>0;r--)t+="w"+r*u+" ";return t}function n(e){e.selectors({prerenderedCard:".PrerenderedCard",cardBreakpointsEl:".TwitterCard .CardContent > *:first-child"}),e.define("scribeCardShown",function(e){var t=2;this.scribe({component:"card",action:"shown"},{items:[{card_name:e.getAttribute("data-card-name")}]},t)}),e.define("displayCardEl",function(e){function t(){r&&i.sandbox.matchHeightToContent()}var i=this,r=!1;return this.select(e,"img").forEach(function(e){e.addEventListener("load",t,!1)}),this.scribeCardShown(e),s.write(function(){a.add(e,"is-ready")}).then(function(){r=!0,i.sandbox.matchHeightToContent()})}),e.define("updateCardBreakpoints",function(){var e=this;return l.all(this.select("prerenderedCard").map(function(t){var i,n=e.selectOne(t,"cardBreakpointsEl");return n?(s.read(function(){var e=o(t).width;i=r(e)}),s.write(function(){n.setAttribute(h,i)})):l.resolve()}))}),e.after("prepForInsertion",function(e){var t=this,i=this.select(e,"prerenderedCard").reduce(function(e,t){var i=t.getAttribute("data-css");return i&&(e[i]=e[i]||[],e[i].push(t)),e},{});d.forIn(i,function(e,i){t.sandbox.prependStyleSheet(e).then(function(){i.forEach(function(e){t.displayCardEl(e)})})})}),e.after("render",function(){return this.updateCardBreakpoints()}),e.after("resize",function(){return this.updateCardBreakpoints()})}var a=i(24),s=i(46),o=i(66),l=i(2),d=i(14),c=i(79),u=50,h="data-card-breakpoints";e.exports=c.couple(i(90),n)},174:function(e,t,i){function r(e){e.selectors({mediaCard:".MediaCard",mediaCardNsfwDismissalTarget:".MediaCard-dismissNsfw"}),e.define("dismissNsfwWarning",function(e,t){var i=n.closest(this.selectors.mediaCard,t,this.el);i&&a.remove(i,"is-nsfw")}),e.after("render",function(){this.on("click","mediaCardNsfwDismissalTarget",this.dismissNsfwWarning)})}var n=i(25),a=i(24);e.exports=r},175:function(e,t,i){function r(e){function t(e){var t=e.createElement("div");return t.className="MediaCard-mediaAsset",t}function i(e){return u.url(e,m)}e.params({lang:{required:!0,transform:d.matchLanguage,fallback:"en"}}),e.selectors({mediaAsset:".MediaCard-mediaAsset",cardInterstitial:".js-cardPlayerInterstitial",wvpInterstitial:".js-playableMediaInterstitial",tweetIdInfo:".js-tweetIdInfo"}),e.define("replaceInterstitialWithMedia",function(e,t){return f.all([this.restoreLastMediaInterstitial(),c.write(function(){n=e,a=e.parentNode,e.parentNode.replaceChild(t,e)})])}),e.define("restoreLastMediaInterstitial",function(){var e;return n&&a?(e=a.firstElementChild,h.remove(e),c.write(function(){a.replaceChild(n,e)})):f.resolve()}),e.define("displayWebVideoPlayerMediaAsset",function(e,i){var r=l.closest(this.selectors.mediaAsset,i,this.el),n=l.closest(this.selectors.tweetIdInfo,i,this.el),a=n.getAttribute("data-tweet-id"),s=(this.scribeNamespace()||{}).page,o=this.params.lang,d=t(this.sandbox),c=this.sandbox.createElement("div");return a?(e.preventDefault(),c.className="wvp-player-container",d.appendChild(c),this.replaceInterstitialWithMedia(r,d).then(function(){var e=h.insert(d,a,s,o);e&&e.on("ready",e.play)})):f.reject(new Error("No Tweet ID for player"))}),e.define("displayIframeMediaAsset",function(e,r){var n,a,d=l.closest(this.selectors.mediaAsset,r,this.el),u=l.closest(this.selectors.cardInterstitial,r,this.el),h=u.getAttribute("data-player-src"),m=u.getAttribute("data-player-width"),g=u.getAttribute("data-player-height"),v=u.getAttribute("data-player-title");return h?(e.preventDefault(),h=i(h),n=t(this.sandbox),a=o({src:h,allowfullscreen:"true",width:m,height:g,title:v||""}),a.className="FilledIframe",n.appendChild(a),this.replaceInterstitialWithMedia(d,n).then(function(){a.focus(),c.write(function(){s.add(n,p),s.add(a,p)})})):f.reject(new Error("No Player frame source"))}),e.after("render",function(){this.on("click","cardInterstitial",this.displayIframeMediaAsset),this.on("click","wvpInterstitial",this.displayWebVideoPlayerMediaAsset)})}var n,a,s=i(24),o=i(52),l=i(25),d=i(87),c=i(46),u=i(28),h=i(176),f=i(2),m={autoplay:"1"},p="js-forceRedraw";e.exports=r},176:function(e,t,i){function r(e,t,i,r){var n=e.querySelector(".wvp-player-container");return n?(s&&a.setBaseUrl(s),a.createPlayerForTweet(n,t,{scribeContext:{client:"tfw",page:i},languageCode:r})):void 0}function n(e){var t=e.querySelector(".wvp-player-container"),i=t&&a.findPlayerForElement(t);return i?i.teardown():void 0}var a=i(177),s=null;e.exports={insert:r,remove:n}},177:function(e,t,i){var r;!function(n,a){r=function(){return n.TwitterVideoPlayer=a()}.call(t,i,t,e),!(void 0!==r&&(e.exports=r))}(this,function(){function e(e){if(e&&e.data&&e.data.params&&e.data.params[0]){var t=e.data.params[0],i=e.data.id;if(t&&t.context&&"TwitterVideoPlayer"===t.context){var r=t.playerId;delete t.playerId,delete t.context;var n=o[r];n&&n.processMessage(e.data.method,t,i)}}}function t(e,t,i){var r=Object.keys(i).filter(function(e){return null!=i[e]}).map(function(e){var t=i[e];return encodeURIComponent(e)+"="+encodeURIComponent(t)}).join("&");return r&&(r="?"+r),e+t+r}function i(i,n,a,l,d){var c=i.ownerDocument,u=c.defaultView;u.addEventListener("message",e),this.playerId=s++;var h={embed_source:"clientlib",player_id:this.playerId,rpc_init:1};if(this.scribeParams={},this.scribeParams.suppressScribing=l&&l.suppressScribing,!this.scribeParams.suppressScribing){if(!l.scribeContext)throw"video_player: Missing scribe context";if(!l.scribeContext.client)throw"video_player: Scribe context missing client property";this.scribeParams.client=l.scribeContext.client,this.scribeParams.page=l.scribeContext.page,this.scribeParams.section=l.scribeContext.section,this.scribeParams.component=l.scribeContext.component}this.scribeParams.debugScribe=l&&l.scribeContext&&l.scribeContext.debugScribing,this.scribeParams.scribeUrl=l&&l.scribeContext&&l.scribeContext.scribeUrl,this.promotedLogParams=l.promotedContext,this.adRequestCallback=l.adRequestCallback,l.languageCode&&(h.language_code=l.languageCode);var f=t(r,n,h);return this.videoIframe=document.createElement("iframe"),this.videoIframe.setAttribute("src",f),this.videoIframe.setAttribute("allowfullscreen",""),this.videoIframe.setAttribute("id",a),this.videoIframe.setAttribute("style","width: 100%; height: 100%; position: absolute; top: 0; left: 0;"),this.domElement=i,this.domElement.appendChild(this.videoIframe),o[this.playerId]=this,this.eventCallbacks={},this.emitEvent=function(e,t){var i=this.eventCallbacks[e];"undefined"!=typeof i&&i.forEach(function(e){e.apply(this.playerInterface,[t])}.bind(this))},this.jsonRpc=function(e){var t=this.videoIframe.contentWindow;e.jsonrpc="2.0",t.postMessage(JSON.stringify(e),"*")},this.jsonRpcCall=function(e,t){this.jsonRpc({method:e,params:t})},this.jsonRpcResult=function(e,t){this.jsonRpc({result:e,id:t})},this.processMessage=function(e,t,i){switch(e){case"requestPlayerConfig":this.jsonRpcResult({scribeParams:this.scribeParams,promotedLogParams:this.promotedLogParams,squareCorners:l.squareCorners,hideControls:l.hideControls},i);break;case"videoPlayerPlaybackComplete":this.emitEvent("playbackComplete",t);break;case"videoPlayerReady":this.emitEvent("ready",t);break;case"videoView":this.emitEvent("view",t);break;case"debugLoggingEvent":this.emitEvent("logged",t);break;case"requestDynamicAd":"function"==typeof this.adRequestCallback?this.jsonRpcResult(this.adRequestCallback(),i):this.jsonRpcResult({},i)}},this.playerInterface={on:function(e,t){return"undefined"==typeof this.eventCallbacks[e]&&(this.eventCallbacks[e]=[]),this.eventCallbacks[e].push(t),this.playerInterface}.bind(this),off:function(e,t){if("undefined"==typeof t)delete this.eventCallbacks[e];else{var i=this.eventCallbacks[e];if("undefined"!=typeof i){var r=i.indexOf(t);r>-1&&i.splice(r,1)}}return this.playerInterface}.bind(this),play:function(){return this.jsonRpcCall("play"),this.playerInterface}.bind(this),pause:function(){return this.jsonRpcCall("pause"),this.playerInterface}.bind(this),mute:function(){return this.jsonRpcCall("mute"),this.playerInterface}.bind(this),unmute:function(){return this.jsonRpcCall("unmute"),this.playerInterface}.bind(this),playPreview:function(){return this.jsonRpcCall("autoPlayPreview"),this.playerInterface}.bind(this),pausePreview:function(){return this.jsonRpcCall("autoPlayPreviewStop"),this.playerInterface}.bind(this),updatePosition:function(e){return this.jsonRpcCall("updatePosition",[e]),this.playerInterface}.bind(this),teardown:function(){this.eventCallbacks={},i.removeChild(this.videoIframe),this.videoIframe=void 0,delete o[this.playerId]}.bind(this)},this.playerInterface}var r="https://twitter.com",n=/^https?:\/\/([a-zA-Z0-9]+\.)*twitter.com(:\d+)?$/,a={suppressScribing:!1,squareCorners:!1,hideControls:!1},s=0,o={};return{setBaseUrl:function(e){n.test(e)?r=e:window.console.error("newBaseUrl "+e+" not allowed")},createPlayerForTweet:function(e,t,r){var n="/i/videos/tweet/"+t,s="player_tweet_"+t;return new i(e,n,s,r||a)},createPlayerForDm:function(e,t,r){var n="/i/videos/dm/"+t,s="player_dm_"+t;return new i(e,n,s,r||a)},findPlayerForElement:function(e){for(var t in o)if(o.hasOwnProperty(t)){var i=o[t];if(i&&i.domElement===e)return i.playerInterface}return null}}})},178:function(e,t,i){function r(e,t,i){var r={};return e=e||{},i&&e.max?r.minPosition=e.max:!i&&e.min?r.maxPosition=e.min:i?r.sinceId=t:r.maxId=t,r}function n(e){e.selectors({timelineTweet:".tweet, .timeline-Tweet",viewport:".stream, .timeline-Viewport",tweetList:".h-feed, .timeline-TweetList",tweetsInStream:".h-feed .tweet, .timeline-Tweet",newTweetsNotifier:".new-tweets-bar",loadMore:".timeline-LoadMore",loadMoreButton:".load-more"}),e.define("gcTweetsSync",function(){var e="custom"===this.el.getAttribute("data-timeline-type"),t=this.selectOne("tweetList");return e?s.resolve():void m(t,y)}),e.define("scribeImpressionsForDynamicTweetSet",function(e,t){var i=u.toRealArray(e.querySelectorAll(this.selectors.timelineTweet)),r=f(i),n=Object.keys(r),a=t?"newer":"older",s=t?w.CLIENT_SIDE_APP:w.CLIENT_SIDE_USER;this.scribe({component:"timeline",element:a,action:"results"},{item_ids:n,item_details:r,event_initiator:s})}),e.define("fetchTweets",function(e,t){function i(e){return"404"===e?a.pollInterval=null:"503"===e&&(a.pollInterval*=1.5),s.reject(e)}function n(i){var r,n,s=a.sandbox.createFragment(),l=a.sandbox.createElement("ol"),d=t?b.NEWER:b.OLDER;return g(a,i,d),l.innerHTML=i.html,r=l.firstElementChild,r&&o.present(r,"tweet")?n=r:r&&(n=a.selectOne(r,"timelineTweet")),n&&"LI"===r.tagName?(n.getAttribute("data-tweet-id")===e&&l.removeChild(r),a.scribeImpressionsForDynamicTweetSet(l,t),a.prepForInsertion(l),u.toRealArray(l.children).forEach(function(e){s.appendChild(e)}),s):s}var a=this,l=r(this.cursors,e,t);return(this.usingRefreshHtml?p.pollRefresh:p.poll)(u.aug(l,this.params)).then(n,i)}),e.define("loadOldTweets",function(){var e=this,t=this.selectLast("tweetsInStream"),i=t&&t.getAttribute("data-tweet-id");return i?this.fetchTweets(i,!1).then(function(t){var i=e.selectOne("tweetList"),r=e.selectOne("loadMore");return l.write(function(){t.childNodes.length>0?i.appendChild(t):(o.add(e.el,"no-more"),r&&o.add(r,C))})}):s.reject(new Error("unable to load more"))}),e.after("loadOldTweets",function(){v.trigger("timelineUpdated",{target:this.sandbox.sandboxEl,region:"older"})}),e.define("loadNewTweets",function(){var e=this,t=this.selectOne("tweetsInStream"),i=t&&t.getAttribute("data-tweet-id");return i?this.fetchTweets(i,!0).then(function(t){var i,r�5�78��]NSMutableData���;]NSMutableDataVNSDataҥ	��O$�,n=e.selectOne("viewport"),a=e.selectOne("tweetList");return 0!==t.childNodes.length?(l.read(function(){i=n.scrollTop,r=n.scrollHeight}),l.defer(function(){var s;return a.insertBefore(t,a.firstElementChild),s=i+n.scrollHeight-r,i>40||e.mouseIsOverWidget?(n.scrollTop=s,void e.showNewTweetsNotifier()):(o.remove(e.el,"pending-scroll-in"),a.style.marginTop="-"+s+"px",l.write(function(){n.scrollTop=0,o.add(e.el,"pending-scroll-in"),a.style.marginTop="",e.gcTweetsSync()}))})):void 0}):s.reject(new Error("unable to load new tweets"))}),e.after("loadNewTweets",function(){v.trigger("timelineUpdated",{target:this.sandbox.sandboxEl,region:"newer"})}),e.define("showNewTweetsNotifier",function(){var e=this,t=this.selectOne("newTweetsNotifier"),i=t&&t.firstElementChild;return d.setTimeout(function(){e.hideNewTweetsNotifier()},x),l.write(function(){t.removeChild(i),t.appendChild(i),o.add(e.el,"pending-new-tweet-display"),o.add(t,"is-displayed")}),l.defer(function(){o.add(e.el,"pending-new-tweet"),o.add(t,"is-opaque")})}),e.define("hideNewTweetsNotifier",function(e){var t=this,i=new a,r=this.selectOne("newTweetsNotifier");return e=e||{},!e.force&&this.mouseIsOverNewTweetsNotifier?(i.resolve(),i.promise):(l.write(function(){o.remove(t.el,"pending-new-tweet"),o.remove(r,"is-opaque")}),d.setTimeout(function(){l.write(function(){o.remove(t.el,"pending-new-tweet-display"),o.remove(r,"is-displayed")}).then(i.resolve,i.reject)},I),i.promise)}),e.define("scrollToTopOfViewport",function(){var e=this.selectOne("viewport");return l.write(function(){e.scrollTop=0,e.focus()})}),e.define("schedulePolling",function(){function e(){i.isPollInProgress=!1}function t(){var n=r||i.pollInterval;n&&d.setTimeout(function(){i.isPollInProgress||(i.isPollInProgress=!0,i.loadNewTweets(i.sandbox).then(e,e)),t()},n)}var i=this,r=c.get("timeline.pollInterval");t()}),e.after("initialize",function(){this.isPollInProgress=!1,this.mouseIsOverWidget=!1,this.mouseIsOverNewTweetsNotifier=!1,this.cursors={},this.pollInterval=1e4}),e.after("render",function(){this.isStaticTimeline||this.isPreviewTimeline||(this.select("timelineTweet").length>0&&this.schedulePolling(),this.on("mouseover",function(){this.mouseIsOverWidget=!0}),this.on("mouseout",function(){this.mouseIsOverWidget=!1}),this.on("mouseover","newTweetsNotifier",function(){this.mouseIsOverNewTweetsNotifier=!0}),this.on("mouseout","newTweetsNotifier",function(){this.mouseIsOverNewTweetsNotifier=!1}),this.on("click","newTweetsNotifier",function(){this.scrollToTopOfViewport(),this.hideNewTweetsNotifier({force:!0})}),this.on("click","loadMoreButton",function(){this.loadOldTweets()}))})}var a=i(1),s=i(2),o=i(24),l=i(46),d=i(7),c=i(17),u=i(14),h=i(79),f=i(111),m=i(159),p=i(160),g=i(163),v=i(32),w=i(179),b=i(164),y=50,x=5e3,I=500,C="is-atEndOfTimeline";e.exports=h.couple(i(90),n)},179:function(e,t){e.exports={CLIENT_SIDE_USER:0,CLIENT_SIDE_APP:2}},180:function(e,t,i){function r(e,t){var i,r,n;return(i=t.getAttribute("data-player"))?(r=e.createElement("iframe"),r.src=i):(n=e.createElement("a"),n.href=t.getAttribute("data-href"),r=e.createElement("img"),r.src=t.getAttribute(d.retina()?"data-image-2x":"data-image"),r.alt=t.getAttribute("data-alt"),n.appendChild(r)),r.title=t.getAttribute("data-title"),{mediaEl:r,rootEl:i?r:n}}function n(e){e.selectors({timelineTweetLegacy:".tweet",timelineTweet:".timeline-Tweet",tweetContent:".e-entry-content",showNsfwButton:".display-sensitive-image",nsfwInterstitial:".nsfw",expandoExpander:".detail-expander"}),e.define("displayNsfwMedia",function(e){var t,i,n,a=e.querySelector(this.selectors.nsfwInterstitial),s=e.querySelector(this.selectors.tweetContent),d=e.querySelector(this.selectors.expandoExpander),c=d&&d.children[0];return a&&s&&c?(t=r(this.sandbox,a),i=t.rootEl,n=t.mediaEl,o.read(function(){var e=l.scaleDimensions(a.getAttribute("data-width"),a.getAttribute("data-height"),s.offsetWidth,a.getAttribute("data-height"));n.width=e.width,n.height=e.height}),o.write(function(){a.parentElement.replaceChild(i,a)})):void 0}),e.after("render",function(){this.on("click","showNsfwButton",function(e,t){var i=s.closest(this.selectors.timelineTweetLegacy,t,this.el),r=s.closest(this.selectors.timelineTweet,t,this.el)||i;r&&(this.displayNsfwMedia(r),a.preventDefault(e))})})}var a=i(23),s=i(25),o=i(46),l=i(116),d=i(8);e.exports=n},181:function(e,t,i){function r(e){e.selectors({shareMenuOpener:".js-showShareMenu",shareMenu:".timeline-ShareMenu",shareMenuTimelineHeader:".timeline-Header",shareMenuTimelineFooter:".timeline-Footer"}),e.define("getHeaderHeight",function(){var e=this.selectOne("shareMenuTimelineHeader");return e?e.getBoundingClientRect().height:0}),e.define("getFooterHeight",function(){var e=this.selectOne("shareMenuTimelineFooter");return e?e.getBoundingClientRect().height:0}),e.define("getShareMenuPositionClass",function(e){var t=e.getBoundingClientRect(),i=t.top-this.getHeaderHeight(),r=this.sandbox.height-t.bottom-this.getFooterHeight();return i>r?l:d}),e.after("render",function(){this.on("click","shareMenuOpener",function(e,t){function i(){n.remove(d,r),l.el.removeEventListener("click",i,!1),s.removeEventListener("click",i,!1)}var r,l=this,d=a.closest(this.selectors.shareMenu,e.target,this.el);e.preventDefault(),d&&(r=this.getShareMenuPositionClass(t),n.add(d,r),o.async(function(){l.el.addEventListener("click",i,!1),s.addEventListener("click",i,!1)}))})})}var n=i(24),a=i(25),s=i(9),o=i(14),l="is-openedAbove",d="is-openedBelow";e.exports=r},182:function(e,t,i){function r(e){var t=e&&e.querySelector("b");return t?(l.write(function(){var i=t.innerText||t.textContent;t.innerHTML=e.getAttribute("data-toggled-text"),e.setAttribute("data-toggled-text",i)}),!0):!1}function n(e){e.selectors({tweetContent:".e-entry-content",expandoLink:".expand",tweetWithExpando:".with-expansion",expandoExpander:".detail-expander",expandoContentContainer:".detail-content"}),e.define("toggleExpandoLegacy",function(e){var t,i=e.querySelector(this.selectors.tweetContent),n=e.querySelector(this.selectors.expandoLink),s=e.querySelector(this.selectors.expandoExpander),o=e.querySelector(this.selectors.expandoContentContainer),m=o&&o.getAttribute("data-expanded-media");if(r(n)){if(a.present(e,u))return l.write(function(){a.remove(e,u),s.style.cssText="",c.remove(e),o.innerHTML=""});if(m){l.read(function(){t=i.clientWidth});var p=this.el.lang,g=this.scribeNamespace().page;return l.write(function(){o.innerHTML=m,c.insert(e,e.getAttribute("data-tweet-id"),g,p),d.retinize(o),d.setSrcForImgs(o,t,l.sync),d.sizeIframes(o,t,h,l.sync),s.style.maxHeight=f,
a.add(e,u)})}return l.write(function(){a.add(e,u)})}}),e.after("render",function(){this.isStaticTimeline||(this.on("click","expandoLink",function(e,t){var i=o.closest(this.selectors.tweetWithExpando,t,this.el),r=e.altKey||e.metaKey||e.shiftKey;i&&!r&&(this.toggleExpandoLegacy(i),s.preventDefault(e))}),this.on("click","tweetWithExpando",function(e,t){o.closest("A",e.target,this.el)||(this.toggleExpandoLegacy(t),s.preventDefault(e))}))})}var a=i(24),s=i(23),o=i(25),l=i(46),d=i(116),c=i(176),u="expanded",h=375,f="500px";e.exports=n},183:function(e,t,i){function r(e,t){var i=c;return t&&(i=[d+" "+c,d+c].join(",")),i+"{border-color:"+e+";}"}function n(e){e.params({theme:{fallback:[l(a.val,a,"widgets:theme"),"light"],validate:o},borderColor:{fallback:[l(a.val,a,"widgets:border-color")],validate:s}}),e.after("render",function(){var e=this.params.borderColor,t="dark"===this.params.theme;e&&this.sandbox.appendCss(r(e,t))})}var a=i(16),s=i(184),o=i(162),l=i(20),d=".thm-dark",c=".customisable-border";e.exports=n},184:function(e,t){function i(e){return r.test(e)}var r=/^#(?:[a-f\d]{3}){1,2}$/i;e.exports=i},185:function(e,t,i){function r(e){return e}function n(e){return f+" "+e}function a(e,t){return e.map(t?n:r).join(",")}function s(e,t){var i=a(m,t),r=a(p,t),n=a(g,t);return[i+"{color:"+e+";}",n+"{background-color:"+e+";}",r+"{color:"+d.lighten(e,.2)+";}"].join("")}function o(e){e.params({theme:{fallback:[h(l.val,l,"widgets:theme"),"light"],validate:u},linkColor:{fallback:h(l.val,l,"widgets:link-color"),validate:c}}),e.after("render",function(){var e=this.params.linkColor,t="dark"===this.params.theme;e&&this.sandbox.appendCss(s(e,t))})}var l=i(16),d=i(186),c=i(184),u=i(162),h=i(20),f=".thm-dark",m=[".customisable",".customisable:link",".customisable:visited"],p=[".customisable:hover",".customisable:focus",".customisable:active",".customisable-highlight:hover",".customisable-highlight:focus","a:hover .customisable-highlight","a:focus .customisable-highlight"],g=["a:hover .ic-mask","a:focus .ic-mask"];e.exports=o},186:function(e,t,i){function r(e){return l.parseInt(e,16)}function n(e){return d.isType("string",e)?(e=e.replace(c,""),e+=3===e.length?e:""):null}function a(e,t){var i,a,s,o;return e=n(e),t=t||0,e?(i=0>t?0:255,t=0>t?-Math.max(t,-1):Math.min(t,1),a=r(e.substring(0,2)),s=r(e.substring(2,4)),o=r(e.substring(4,6)),"#"+(16777216+65536*(Math.round((i-a)*t)+a)+256*(Math.round((i-s)*t)+s)+(Math.round((i-o)*t)+o)).toString(16).slice(1)):void 0}function s(e,t){return a(e,-t)}function o(e,t){return a(e,t)}var l=i(7),d=i(14),c=/^#/;e.exports={darken:s,lighten:o}},187:function(e,t,i){function r(e){e.after("render",function(){var e,t=this.sandbox.sandboxEl,i=t.tagName;return a(t,"td "+i)?(e=n.closest("td",t),this.sandbox.styleSelf({maxWidth:e.clientWidth+"px"})):void 0})}var n=i(25),a=i(74);e.exports=r}});�5�78��WNSArray��;�78��_NSCachedURLResponse��;_NSCachedURLResponse_NSKeyedArchiverѹ�Troot�    # - 2 7 s y � � � � � � � � � � � � � � "%(+/258;=?ACEFHJLNPRT[coqsu���������	)+-/13579;=?ACEGIKMbdfhjlnprtvxz|~�����������������	"'5]z~�����;[a~���������(-?CU^cw{���������i i"i'i5i9iGiNiS��� �(�+�0�F�I�_�q�t�y             �              �{