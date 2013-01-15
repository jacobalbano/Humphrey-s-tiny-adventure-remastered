package
{
	import com.thaumaturgistgames.flakit.Library;
	import flash.utils.ByteArray;
	
	/**
	* Generated with LibraryBuilder for FLAKit
	* http://www.thaumaturgistgames.com/FLAKit
	*/
	public class EmbeddedAssets
	{
		[Embed(source = "../lib/ogmo/ambiance.png")] private const FLAKIT_ASSET$26896941:Class;
		[Embed(source = "../lib/ogmo/background.png")] private const FLAKIT_ASSET$_1157757234:Class;
		[Embed(source = "../lib/ogmo/camera.png")] private const FLAKIT_ASSET$_862204225:Class;
		[Embed(source = "../lib/ogmo/climate.png")] private const FLAKIT_ASSET$910413312:Class;
		[Embed(source = "../lib/ogmo/Decal.png")] private const FLAKIT_ASSET$338515033:Class;
		[Embed(source = "../lib/ogmo/emitter.png")] private const FLAKIT_ASSET$_438935123:Class;
		[Embed(source = "../lib/ogmo/invitem.png")] private const FLAKIT_ASSET$_612164355:Class;
		[Embed(source = "../lib/ogmo/worldreaction.png")] private const FLAKIT_ASSET$_386300015:Class;
		[Embed(source = "../lib/ogmo/worldSound.png")] private const FLAKIT_ASSET$1161070485:Class;
		[Embed(source = "../lib/art/particles/flame_01.png")] private const FLAKIT_ASSET$_1946428317:Class;
		[Embed(source = "../lib/art/particles/flame_02.png")] private const FLAKIT_ASSET$_1956717469:Class;
		[Embed(source = "../lib/art/particles/flame_03.png")] private const FLAKIT_ASSET$_1958880157:Class;
		[Embed(source = "../lib/art/particles/smoke.png")] private const FLAKIT_ASSET$_489507794:Class;
		[Embed(source = "../lib/art/particles/snowflake.png")] private const FLAKIT_ASSET$_430274975:Class;
		[Embed(source = "../lib/sounds/windHowl.mp3")] private const FLAKIT_ASSET$_531661301:Class;
		[Embed(source = "../lib/Library.xml", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$_1371418527:Class;
		[Embed(source = "../lib/script.xml", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$997997091:Class;
		[Embed(source = "../lib/worlds/start/map.oel", mimeType = "application/octet-stream")] private const FLAKIT_ASSET$_475205487:Class;
		
		public function EmbeddedAssets()
		{
			Library.addImage(new String("ogmo/ambiance.png").split("/").join("."), new FLAKIT_ASSET$26896941);
			Library.addImage(new String("ogmo/background.png").split("/").join("."), new FLAKIT_ASSET$_1157757234);
			Library.addImage(new String("ogmo/camera.png").split("/").join("."), new FLAKIT_ASSET$_862204225);
			Library.addImage(new String("ogmo/climate.png").split("/").join("."), new FLAKIT_ASSET$910413312);
			Library.addImage(new String("ogmo/Decal.png").split("/").join("."), new FLAKIT_ASSET$338515033);
			Library.addImage(new String("ogmo/emitter.png").split("/").join("."), new FLAKIT_ASSET$_438935123);
			Library.addImage(new String("ogmo/invitem.png").split("/").join("."), new FLAKIT_ASSET$_612164355);
			Library.addImage(new String("ogmo/worldreaction.png").split("/").join("."), new FLAKIT_ASSET$_386300015);
			Library.addImage(new String("ogmo/worldSound.png").split("/").join("."), new FLAKIT_ASSET$1161070485);
			Library.addImage(new String("art/particles/flame_01.png").split("/").join("."), new FLAKIT_ASSET$_1946428317);
			Library.addImage(new String("art/particles/flame_02.png").split("/").join("."), new FLAKIT_ASSET$_1956717469);
			Library.addImage(new String("art/particles/flame_03.png").split("/").join("."), new FLAKIT_ASSET$_1958880157);
			Library.addImage(new String("art/particles/smoke.png").split("/").join("."), new FLAKIT_ASSET$_489507794);
			Library.addImage(new String("art/particles/snowflake.png").split("/").join("."), new FLAKIT_ASSET$_430274975);
			Library.addSound(new String("sounds/windHowl.mp3").split("/").join("."), new FLAKIT_ASSET$_531661301);
			Library.addXML(new String("Library.xml").split("/").join("."), getXML(FLAKIT_ASSET$_1371418527));
			Library.addXML(new String("script.xml").split("/").join("."), getXML(FLAKIT_ASSET$997997091));
			Library.addXML(new String("worlds/start/map.oel").split("/").join("."), getXML(FLAKIT_ASSET$_475205487));
		}
		private function getXML(c:Class):XML{var d:ByteArray = new c;var s:String = d.readUTFBytes(d.length);return new XML(s);}
	}
}
