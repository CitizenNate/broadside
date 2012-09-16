


class Vector extends BroadsideObject{
  num x;
  num y;
  Vector(this.x,this.y);
  bool equals (o) => o is Vector && x==o.x && y==o.y;
  String toString()=>"[Vector x:$x y:$y]";

  void add(Vector other) {
    x+=other.x;
    y+=other.y;
  }
}
class Size extends BroadsideObject{
  num width;
  num height;
  Size(this.width,this.height);
  bool equals (o) => o is Size && width==o.width && height==o.height;
  String toString() => "[Size width:$width height:$height]";
}
class Shape{
}
class Span extends BroadsideObject implements Shape{
  final num start;
  final num end;
  Span(this.start,this.end);
  bool equals (o) => o is Span && start==o.start && end==o.end;
  String toString() => "[Span start:$start end:$end]";
}
class Rectangle extends BroadsideObject implements Shape{
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
  
  Span get xspan => new Span(x,x+width);
  Span get yspan => new Span(y,y+height);
  
  Rectangle(x,y,width,height){
    point=new Vector(x,y);
    size=new Size(width,height);
  }
  Rectangle.fromPointAndSize(this.point,this.size);
  bool equals (o) => o is Rect && point==o.point && size==o.size;
  String toString() => "[Rect point:$point size:$size]";
  Rectangle union(Rectangle other){
    num x1=min(x,other.x);
    num y1=min(y,other.y);
    num x2=max(x+width,other.x+other.width);
    num y2=max(y+height,other.y+other.height);
    return new Rectangle(x1,y1,x2-x1,y2-y1);
  }
}
