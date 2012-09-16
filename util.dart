class TypeNode{
  var userData;
  int index;
  TypeTree tree;
  List<TypeNode> children=new List();
  List<TypeNode> parents=new List();
  TypeNode([this.userData]);
  bool isChildOf(TypeNode parent){
    return tree.isChild(parent,this);
  }
}
class TypeTree{
  List<TypeNode> classes;
  TypeNode root;
  TypeTree(this.root){
    classes=new List();
    addClass(root);
  }
  void addClass(TypeNode clazz){
    clazz.index=classes.length;
    clazz.tree=this;
    classes.add(clazz);
    addInheritance(root,clazz);
  }
  bool isChild(TypeNode parent,TypeNode child){
    if(parent==child){
      return true;
    }
    //TODO efficiency
    if(parent.children.indexOf(child)!=-1){
      return true;
    }else{
      for(int i=0;i<child.parents.length;i++){
        if(isChild(parent,child.parents[i])){
          return true;
        }
      }
      return false;
    }
  }
  void addInheritance(TypeNode parent,TypeNode child){
    if(child==parent){
      return;
    }
    if(isChild(child,parent)){
      print("warning: already a child ");
    }
    parent.children.add(child);
    child.parents.add(parent);
  }
}
class TypeGraph{
  TypeTree hierarchy;
  List<List<bool>> matrix;
  TypeGraph(this.hierarchy){
    int dim=hierarchy.classes.length;
    matrix=tabulate(dim,(x)=>tabulate(dim,(y)=>false));
  }
  bool isAdjacent(TypeNode a,TypeNode b){
    return matrix[a.index][b.index];
  }
}
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
void listRemove(List list,var x){
  int index=list.indexOf(x);
  if(index==-1){
    throw new Exception("No such element");
  }
  list.removeRange(index,1);
}
listFold(Function add,List list,[empty=null]){
  if(list.length==0){
    return empty;
  }else{
    var accum=list[0];
    for(int i=1;i<list.length;i++){
      accum=add(accum,list[i]);
    }
    return accum;
  }
}