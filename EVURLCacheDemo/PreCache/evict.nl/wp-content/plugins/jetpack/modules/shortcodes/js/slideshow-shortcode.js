bplist00���X$versionX$objectsY$archiverT$top ���-/56<=>\]^_`abcdefghijklmnopqrstxy}�������U$null�	
V$classR$0__NSURLResponseTypeR$1_%_CFCachedURLResponseReceiverDataArray__NSDictionaryType[_NSDataType�,� �'� � �	 
!"#$%&'()*+,-.R$6S$10R$2R$7R$3S$11R$8R$4R$9R$5�	�	��#�&��$��0	134WNS.base[NS.relative� ��_fhttp://evict.nl/wp-content/plugins/jetpack/modules/shortcodes/js/slideshow-shortcode.js?ver=20121214.1�789:Z$classnameX$classesUNSURL�9;XNSObject#A�y��`o���?@	AN[WNS.keysZNS.objects�BCDEFGHIJKLM�
������������OPQRSTUVWXYZ����������� �!�"\Content-Type]X-Proxy-Cache]Accept-Ranges_Content-EncodingVServerTDate[Host-Header^Content-LengthZConnectionTEtagTVary]Last-Modified_application/javascriptTMISSUbytesTgzipUnginx_Sun, 21 Feb 2016 08:37:54 GMT_ 192fc2e7e50945beb8231a492d6a8024T1838Zkeep-alive_"a99289a-15cb-52babcef332c0"_Accept-Encoding_Sat, 13 Feb 2016 19:29:55 GMT�78uv\NSDictionary�w;\NSDictionary��	z{|YNS.string�%_application/javascript�78~_NSMutableString���;_NSMutableStringXNSString�78��_NSHTTPURLResponse���;_NSHTTPURLResponse]NSURLResponse�@	������(�*�+ҍ	��WNS.dataO
Z/* jshint onevar:false, loopfunc:true */
/* global jetpackSlideshowSettings, escape */

function JetpackSlideshow( element, transition, autostart ) {
	this.element = element;
	this.images = [];
	this.controls = {};
	this.transition = transition || 'fade';
	this.autostart = autostart;
}

JetpackSlideshow.prototype.showLoadingImage = function( toggle ) {
	if ( toggle ) {
		this.loadingImage_ = document.createElement( 'div' );
		this.loadingImage_.className = 'slideshow-loading';
		var img = document.createElement( 'img' );
		img.src = jetpackSlideshowSettings.spinner;
		this.loadingImage_.appendChild( img );
		this.loadingImage_.appendChild( this.makeZeroWidthSpan() );
		this.element.append( this.loadingImage_ );
	} else if ( this.loadingImage_ ) {
		this.loadingImage_.parentNode.removeChild( this.loadingImage_ );
		this.loadingImage_ = null;
	}
};

JetpackSlideshow.prototype.init = function() {
	this.showLoadingImage(true);

	var self = this;
	// Set up DOM.
	for ( var i = 0; i < this.images.length; i++ ) {
		var imageInfo = this.images[i];
		var img = document.createElement( 'img' );
		img.src = imageInfo.src;
		img.title = typeof( imageInfo.title ) !== 'undefined' ? imageInfo.title : '';
		img.alt = typeof( imageInfo.alt ) !== 'undefined' ? imageInfo.alt : '';
		img.align = 'middle';
		img.nopin = 'nopin';
		var caption = document.createElement( 'div' );
		caption.className = 'slideshow-slide-caption';
		caption.innerHTML = imageInfo.caption;
		var container = document.createElement('div');
		container.className = 'slideshow-slide';

		// Hide loading image once first image has loaded.
		if ( i === 0 ) {
			if ( img.complete ) {
				// IE, image in cache
				setTimeout( function() {
					self.finishInit_();
				}, 1);
			} else {
				jQuery( img ).load(function() {
					self.finishInit_();
				});
			}
		}
		container.appendChild( img );
		// I'm not sure where these were coming from, but IE adds
		// bad values for width/height for portrait-mode images
		img.removeAttribute('width');
		img.removeAttribute('height');
		container.appendChild( this.makeZeroWidthSpan() );
		container.appendChild( caption );
		this.element.append( container );
	}
};

JetpackSlideshow.prototype.makeZeroWidthSpan = function() {
	var emptySpan = document.createElement( 'span' );
	emptySpan.className = 'slideshow-line-height-hack';
	// Having a NBSP makes IE act weird during transitions, but other
	// browsers ignore a text node with a space in it as whitespace.
	if ( -1 !== window.navigator.userAgent.indexOf( 'MSIE ' ) ) {
		emptySpan.appendChild( document.createTextNode(' ') );
	} else {
		emptySpan.innerHTML = '&nbsp;';
	}
�)�78��]NSMutableData���;]NSMutableDataVNSDataҍ	��Oq	return emptySpan;
};

JetpackSlideshow.prototype.finishInit_ = function() {
	this.showLoadingImage( false );
	this.renderControls_();

	var self = this;
	if ( this.images.length > 1 ) {
		// Initialize Cycle instance.
		this.element.cycle( {
			fx: this.transition,
			prev: this.controls.prev,
			next: this.controls.next,
			slideExpr: '.slideshow-slide',
			onPrevNextEvent: function() {
				return self.onCyclePrevNextClick_.apply( self, arguments );
			}
		} );

		var slideshow = this.element;

		if ( ! this.autostart ) {
			slideshow.cycle( 'pause' );
			jQuery(this.controls.stop).removeClass( 'running' );
			jQuery(this.controls.stop).addClass( 'paused' );
		}

		jQuery( this.controls.stop ).click( function() {
			var button = jQuery(this);
			if ( ! button.hasClass( 'paused' ) ) {
				slideshow.cycle( 'pause' );
				button.removeClass( 'running' );
				button.addClass( 'paused' );
			} else {
				button.addClass( 'running' );
				button.removeClass( 'paused' );
				slideshow.cycle( 'resume', true );
			}
			return false;
		} );
	} else {
		this.element.children( ':first' ).show();
		this.element.css( 'position', 'relative' );
	}
	this.initialized_ = true;
};

JetpackSlideshow.prototype.renderControls_ = function() {
	if ( this.controlsDiv_ ) {
		return;
	}

	var controlsDiv = document.createElement( 'div' );
	controlsDiv.className = 'slideshow-controls';

	var controls = [ 'prev', 'stop', 'next' ];
	for ( var i = 0; i < controls.length; i++ ) {
		var controlName = controls[i];
		var a = document.createElement( 'a' );
		a.href = '#';
		controlsDiv.appendChild( a );
		this.controls[controlName] = a;
	}
	this.element.append( controlsDiv );
	this.controlsDiv_ = controlsDiv;
};

JetpackSlideshow.prototype.onCyclePrevNextClick_ = function( isNext, i/*, slideElement*/ ) {
	// If blog_id not present don't track page views
	if ( ! jetpackSlideshowSettings.blog_id ) {
		return;
	}

	var postid = this.images[i].id;
	var stats = new Image();
	stats.src = document.location.protocol +
		'//pixel.wp.com/g.gif?host=' +
		escape( document.location.host ) +
		'&rand=' + Math.random() +
		'&blog=' + jetpackSlideshowSettings.blog_id +
		'&subd=' + jetpackSlideshowSettings.blog_subdomain +
		'&user_id=' + jetpackSlideshowSettings.user_id +
		'&post=' + postid +
		'&ref=' + escape( document.location );
};

( function ( $ ) {
	function jetpack_slideshow_init() {
		$( '.jetpack-slideshow-noscript' ).remove();

		$( '.jetpack-slideshow' ).each( function () {
			var container = $( this );

			if ( container.data( 'processed' ) ) {
				return;
			}

			var slideshow = new JetpackSlideshow( container, container.data( 'trans' ), container.data( 'autostart' ) );
			slideshow.images = container.data( 'gallery' );
			slideshow.init();

			container.data( 'processed', true );
		} );
	}

	$( document ).ready( jetpack_slideshow_init );
	$( 'body' ).on( 'post-load', jetpack_slideshow_init );
} )( jQuery );
�)�78��WNSArray��;�78��_NSCachedURLResponse��;_NSCachedURLResponse_NSKeyedArchiverѡ�Troot�    # - 2 7 g m | � � � � � � � � � � � � � �#&),/13579:<>@BDFHOWcegi�������"/13579;=?ACEGTVXZ\^`bdfhjln{�����������#Cfkv�����������-1CLQei}��������+27���������             �              