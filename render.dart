class Drawable{
  abstract void draw(CanvasRenderingContext2D g);
}
class FilledRectangle implements Drawable{
  Rectangle rect;
  FilledRectangle(this.rect);
  void draw(CanvasRenderingContext2D context){
    context.fillRect(rect.x, rect.y, rect.width, rect.height);
  }
}
class Group implements Drawable{
  List<Drawable> elements;
  Group(this.elements);
  void draw(CanvasRenderingContext2D g){
    elements.forEach((e)=>e.draw(g));
  }
}
class Transform implements Drawable{
  Drawable inner;
  Transform(this.inner);
  abstract void transform(CanvasRenderingContext2D g);
  void draw(CanvasRenderingContext2D g){
    g.save();
    transform(g);
    inner.draw(g);
    g.restore();
  }
}
class AffineTransform extends Transform{
  num m11=1,m12=0,m21=0,m22=1,dx=0,dy=0;
  AffineTransform.translate(Drawable inner,this.dx,this.dy):super(inner);
  void transform(CanvasRenderingContext2D g){
    g.transform(m11,m12,m21,m22,dx,dy);
  }
}
class GraphicsAttribute{
  String name;
  GraphicsAttribute(this.name);
  static GraphicsAttribute get fillStyle()=>new GraphicsAttribute("fillStyle");
  static GraphicsAttribute get strokeStyle()=>new GraphicsAttribute("strokeStyle");
}
class AttributeTransform extends Transform{
  GraphicsAttribute attr;
  var value;
  AttributeTransform(Drawable inner,GraphicsAttribute attr,var value):super(inner){
    this.attr=attr;
    this.value=value;
  }
  void transform(CanvasRenderingContext2D g){
    if(attr.name==null){
      throw new IllegalArgumentException();
    }
    switch(attr.name){
      case "fillStyle":g.fillStyle=value;break;
      case "strokeStyle":g.strokeStyle=value;break;
      default:throw new IllegalArgumentException(attr.name);
    }
  }
}
void render(String canvas,Drawable d){
  CanvasElement ce=query(canvas);
  CanvasRenderingContext2D g=ce.context2d;
  g.clearRect(0, 0, ce.width, ce.height);
  d.draw(g);
}