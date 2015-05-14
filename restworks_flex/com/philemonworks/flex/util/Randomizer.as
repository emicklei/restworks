package com.philemonworks.flex.util
{
	public class Randomizer
	{
		public function nextPositiveInt():int {
			return nextInt(1,65535) // how to access MAX_VALUE ?
		}
		public function nextForename():String {
			var names:Array = ["Albert","Bob","Caroline","Daisy","Emile","Frank","Gerard","Hiro","Ike","James","Kurt","Leonard","Mike","Oscar","Peter"]
			return names[nextInt(0,names.length)]
		}
		public function nextLastname():String {
			var names:Array = ["Arlington","Bolton","Caesar","Darko","Hilton","Fockers","Lector"]
			return names[nextInt(0,names.length)]
		}
		public function nextDate():Date {
			return new Date(nextInt(1970,2007),nextInt(1,12),nextInt(1,28))
		}		
		public function nextInt(min:int,max:int):int {
			return Math.round(min + Math.random()*(max - min))
		}
		public function nextFloat(min:Number,max:Number):Number {
			return min + Math.random()*(max - min)
		}
		public function nextBoolean():Boolean {
			return Math.random() < 0.5
		}
	}
}