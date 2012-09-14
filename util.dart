class TypeNode{
  var userData;
  int index;
  TypeTree tree;
  List<TypeNode> children;
  List<TypeNode> parents;
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