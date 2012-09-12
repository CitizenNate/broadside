
class BroadsideObject{
  abstract bool equals(o);
  bool operator==(o)=>
      o!==null && (this===o || this.equals(o));
}

class Vector extends BroadsideObject{
  num x;
  num y;
  Vector(this.x,this.y);
  bool equals (o) => o is Vector && x==o.x && y==o.y;
  String toString()=>"[Vector x:$x y:$y]";
}
class Size extends BroadsideObject{
  num width;
  num height;
  Size(this.width,this.height);
  bool equals (o) => o is Size && width==o.width && height==o.height;
  String toString() => "[Size width:$width height:$height]";
}
class Rectangle extends BroadsideObject{
  Vector point;
  Size size;
  
  num get x => point.x;
  void set x(x) { point.x=x;}
  
  num get y => point.y;
  void set y(y) {point.y=y;}
  
  num get width => size.width;
  void set width(width) {size.width=width;}
  
  num get height => size.height;
  void set height(height ) {size.height=height;}
  
  Rectangle(x,y,width,height){
    point=new Vector(x,y);
    size=new Size(width,height);
  }
  Rectangle.fromPointAndSize(this.point,this.size);
  bool equals (o) => o is Rect && point==o.point && size==o.size;
  String toString() => "[Rect point:$point size:$size]";
}
