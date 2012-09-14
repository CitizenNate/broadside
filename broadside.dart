#library('broadside');
#import('dart:html');
#import('dart:mirrors');
#import('dart:math');
#source('util.dart');
#source('geom.dart');
#source('render.dart');
#source('timer.dart');
#source('collision.dart');
class BroadsideObject{
  abstract bool equals(o);
  bool operator==(o)=>
      o!==null && (this===o || this.equals(o));
}
class Pair<A,B>{
  final A a;
  final B b;
  Pair(this.a,this.b);
  static second(Pair pair){
    return pair.b;
  }
  static first(Pair pair){
    return pair.a;
  }
}
List tabulate(int length,Dynamic f(int)){
  List ret=new List(length);
  for(int i=0;i<length;i++){
    ret[i]=f(i);
  }
}
