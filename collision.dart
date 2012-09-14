
class BinaryCollision{
  abstract bool isColliding(Shape a,Shape b);
  abstract bool accepts(Shape shape);
}
class SpanBinaryCollision implements BinaryCollision{
  bool accepts(Shape shape){
    return shape is Span;
  }
  bool isColliding(Shape a,Shape b){
    if(!(a is Span) || !(b is Span)){
      throw new IllegalArgumentException("SpanCollisionImplementation can only handle spans");
    }
  }
}
class RectangleBinaryCollision implements BinaryCollision{
  BinaryCollision spanBC=new SpanBinaryCollision();
  bool accepts(Shape shape){
    return shape is Rectangle;
  }
  bool isColliding(Shape a,Shape b){
    if(!(a is Rectangle) || !(b is Rectangle)){
      throw new IllegalArgumentException("RectangleCollisionImplementation can only handle rectangles");
    }
    Rectangle r1=a;
    Rectangle r2=b;
    return(spanBC.isColliding(r1.xspan, r2.xspan) && spanBC.isColliding(r1.yspan, r2.yspan));
  }
}
class Collider{
  var owner=null;
  Shape shape;
  CollisionSystem system;
  TypeNode type;
  int id;
  List<Collider> cached=new List();
  Collider(this.system,this.owner,this.shape,this.type);
  void unregister(){
    int index=system.colliders.indexOf(this);
    system.colliders.removeRange(index,1);
  }
  List<Collider> getCollisions(TypeNode others){
    return system.getCollisionsCT(this,others);
  }
  bool isColliding(Collider other){
    return system.binary.isColliding(this.shape,other.shape);
  }
}

class CollisionSystem{
  bool cached;
  TypeGraph cacheRequest;
  List<Collider> colliders=new List();
  BinaryCollision binary;
  int idCounter=0;
  CollisionSystem(this.binary,this.cached);
  Collider register(var owner,Shape shape,TypeNode type){
    Collider ret=new Collider(this,owner,shape,type);
    ret.id=idCounter++;
    colliders.add(ret);
    return ret;
  }
  void recalculate(){
    colliders.forEach((collider)=>collider.cached.clear());
    getCollisionsTTImpl(cacheRequest).forEach((p){
      p.a.cached.add(p.b);
      p.b.cached.add(p.a);
    });
  }
  List<Collider> getCollisionsCT(Collider c,TypeNode other){
    if(cached){
      return c.cached.filter((c2)=>c2.type.isChildOf(other));
    }else{
      return getCollisionsCTImpl(c,other);
    }
  }
  List<Pair<Collider,Collider>> getCollisionsTT(TypeGraph types){
    if(cached){
      List ret=new List();
      colliders.forEach((c){
        c.cached.forEach((c2){
          if(types.isAdjacent(c.type,c2.type)){
            ret.add(new Pair(c,c2));
          }
        });
      });
    }else{
      return getCollisionsTTImpl(types);
    }
  }
  List<Collider> getCollisionsCTImpl(Collider c,TypeNode others){
    List ret=new List();
    colliders.forEach((Collider c2){
      if(c!=c2 && c2.type.isChildOf(others)){
        if(binary.isColliding(c.shape, c2.shape)){
          ret.add(c2);
        }
      }
    });
    return ret;
  }
  List<Pair<Collider,Collider>> getCollisionsTTImpl(TypeGraph types){
    //TODO prefilter?
    //TODO triangular loop
    List ret=new List();
    colliders.forEach((Collider c1){
      colliders.forEach((Collider c2){
        if(c1.id<c2.id){
          if(types.isAdjacent(c1.type,c2.type)){
            if(binary.isColliding(c1.shape,c2.shape)){
              ret.add(new Pair(c1,c2));
            }
          }
        }
      });
    });
    return ret;
  }
}
class TreeCollisionSystem extends CollisionSystem{
  TreeCollisionSystem(binary,cached):super(binary,cached);
  List<Collider> getCollisionsCTImpl(Collider c,TypeNode others){
    throw new Exception();
  }
  List<Pair<Collider,Collider>> getCollisionsTTImpl(TypeGraph types){
    throw new Exception();
  }
}
