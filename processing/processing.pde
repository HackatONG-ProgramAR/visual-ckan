/**
 * Simmple graph layout system
 * http://processingjs.nihongoresources.com/graphs
 * This code is in the public domain
 */

DirectedGraph g=null;
int padding=30;
JSONArray graph;
int x=1000;
int y=600;
void setup()
{
  size(x,y);
  frameRate(24);
  draw();
  g.draw();
//  noLoop();
 
}

void draw()
{
  graph= loadJSONArray("/home/nando/Desktop/a.json");
  createGraph(graph);
  //redraw();
}

void keyPressed()
{
  // tree
  if(key=='e' || key=='E') {
    makeGraph2();
    g.draw(); 
    redraw(); }

}

void mousePressed() {
  if (((padding-2<=mouseX) && (mouseX<=padding+2)) && ((padding-2<=mouseY) && (mouseY<=padding+2))) {
    JSONArray hijos=graph.getJSONObject(0).getJSONArray("hijos");
    Node n;
    int dis= x/hijos.size();
    for(int i=0; i<hijos.size(); i++){
      n= new Node(hijos.getJSONObject(i).getString("title"),1+(dis*i),100);
      g.addNode(n);
      g.linkNodes(g.getNode(0),n);  
    }
    g.draw(); 
    redraw();;
  }
}

void createGraph(JSONArray graph){
   g=new DirectedGraph();
   String name= graph.getJSONObject(0).getJSONObject("metadatos").getString("title");
   Node n1= new Node(name, padding, padding);
   g.addNode(n1);
} 


void makeGraphElecciones()
{
  // define a graph
  g = new DirectedGraph();

  // define some nodes
  Node n1 = new Node("Elecciones",padding,padding);
  g.addNode(n1);
/*  Node n2 = new Node("2",padding,height-padding);
  Node n3 = new Node("3",width-padding,height-padding);
  Node n4 = new Node("4",width-padding,padding);
  Node n5 = new Node("5",width-3*padding,height-2*padding);
  Node n6 = new Node("6",width-3*padding,2*padding);

  // add nodes to graph
 
  g.addNode(n2);
  g.addNode(n3);
  g.addNode(n4);
  g.addNode(n5);
  g.addNode(n6);

  // link nodes
  g.linkNodes(n1,n2);
  g.linkNodes(n2,n3);
  g.linkNodes(n3,n4);
  g.linkNodes(n4,n1);
  g.linkNodes(n1,n3);
  g.linkNodes(n2,n4);
  g.linkNodes(n5,n6);
  g.linkNodes(n1,n6);
  g.linkNodes(n2,n5);*/
}

void makeGraph2(){
  g = new DirectedGraph();
  // define some nodes
  Node n1 = new Node("Elecciones",padding,padding);
  g.addNode(n1);
  Node n2= new Node("Año 2003",100,10);
  Node n3= new Node("Año 2007",20,200);
  Node n4= new Node("Año 20011",250,250);
  g.addNode(n2);
  g.addNode(n3);
  g.addNode(n4);
     
  g.linkNodes(n1,n2);
  g.linkNodes(n1,n3);
  g.linkNodes(n1,n4);
  
}
void makeTree()
{
  // define a root node
  Node root = new Node("root",0,0);

  // define a Tree
  g = new Tree(root);

  // techincall g is of type DirectedGraph, so build a Tree alias:
  Tree t = (Tree) g;

  // define some children
  Node ca = new Node("a",0,0);
  Node caa = new Node("aa",0,0);
  Node cab = new Node("ab",0,0);
  Node cb = new Node("b",0,0);
  Node cba = new Node("ba",0,0);
  Node cbb = new Node("bb",0,0);
  Node cbba = new Node("bba",0,0);
  Node cbbb = new Node("bbb",0,0);
  Node cbbba = new Node("bbba",0,0);
  Node cbbbb = new Node("bbbb",0,0);

  // add all nodes to tree
  t.addChild(root, ca);
  t.addChild(root, cb);
  t.addChild(ca, caa);
  t.addChild(ca, cab);
  t.addChild(cb, cba);
  t.addChild(cb, cbb);
  t.addChild(cbb, cbba);
  t.addChild(cbb, cbbb);
  t.addChild(cbbb, cbbba);
  t.addChild(cbbb, cbbbb);
}

/**
 * Simmple graph layout system
 * http://processingjs.nihongoresources.com/graphs
 * This code is in the public domain
 */

/**
 * Flow algorithm for drawing nodes in a circle
 */
class CircleFlowAlgorithm implements FlowAlgorithm
{
  // draw all nodes in a big circle,
  // without trying to find the best
  // arrangement possible.

  boolean reflow(DirectedGraph g)
  {
    float interval = 2*PI / (float)g.size();
    int cx = width/2;
    int cy = height/2;
    float vl = cx - (2*g.getNode(0).r1) - 10;
    for(int a=0; a<g.size(); a++)
    {
      int[] nc = rotateCoordinate(vl, 0, (float)a*interval);
      g.getNode(a).x = cx+nc[0];
      g.getNode(a).y = cy+nc[1];
    }
    return true;
  }
}

/**
 * Simmple graph layout system
 * http://processingjs.nihongoresources.com/graphs
 * This code is in the public domain
 */

// this class models a directed graph, consisting of any number of nodes
class DirectedGraph
{
  ArrayList<Node> nodes = new ArrayList<Node>();
  FlowAlgorithm flower = new CircleFlowAlgorithm();

  void setFlowAlgorithm(FlowAlgorithm f) {
    flower = f; }

  void addNode(Node node) {
    if(!nodes.contains(node)) {
      nodes.add(node); }}

  int size() { return nodes.size(); }

  boolean linkNodes(Node n1, Node n2) {
    if(nodes.contains(n1) && nodes.contains(n2)) {
      n1.addOutgoingLink(n2);
      n2.addIncomingLink(n1);
      return true; }
    return false; }

  Node getNode(int index) {
    return nodes.get(index); }

  ArrayList<Node> getNodes() {
    return nodes; }

  ArrayList<Node> getRoots() {
    ArrayList<Node> roots = new ArrayList<Node>();
    for(Node n: nodes) {
      if(n.getIncomingLinksCount()==0) {
        roots.add(n); }}
    return roots; }

  ArrayList<Node> getLeaves() {
    ArrayList<Node> leaves = new ArrayList<Node>();
    for(Node n: nodes) {
      if(n.getOutgoingLinksCount()==0) {
        leaves.add(n); }}
    return leaves; }

  // the method most people will care about
  boolean reflow() { return flower.reflow(this); }

  // this does nothing other than tell nodes to draw themselves.
  void draw() {
    for(Node n: nodes) {
      n.draw(); }}
}

/**
 * Simmple graph layout system
 * http://processingjs.nihongoresources.com/graphs
 * This code is in the public domain
 */

/**
 * Flow algorithm that positions nodes by
 * prentending the links are elastic. This
 * is a multiple-step algorithm, and has
 * to be run several times before it's "done".
 */
class ForceDirectedFlowAlgorithm implements FlowAlgorithm
{
  float min_size = 80.0;
  float elasticity = 200.0;
  void setElasticity(float e) { elasticity = e; }

  float repulsion = 4.0;
  void setRepulsion(float r) { repulsion = r; }

  // this is actually a simplified force
  // directed algorithm, taking into account
  // only incoming links.

  boolean reflow(DirectedGraph g)
  {
    ArrayList<Node> nodes = g.getNodes();
    int reset = 0;
    for(Node n: nodes)
    {
      ArrayList<Node> incoming = n.getIncomingLinks();
      ArrayList<Node> outgoing = n.getOutgoingLinks();
      // compute the total push force acting on this node
      int dx = 0;
      int dy = 0;
      for(Node ni: incoming) {
        dx += (ni.x-n.x);
        dy += (ni.y-n.y); }
      float len = sqrt(dx*dx + dy*dy);
      float angle = getDirection(dx, dy);
      int[] motion = rotateCoordinate(0.9*repulsion,0.0,angle);
      // move node
      int px = n.x;
      int py = n.y;
      n.x += motion[0];
      n.y += motion[1];
      if(n.x<0) { n.x=0; } else if(n.x>width) { n.x=width; }
      if(n.y<0) { n.y=0; } else if(n.y>height) { n.y=height; }
      // undo repositioning if elasticity is violated
      float shortest = n.getShortestLinkLength();
      if(shortest<min_size || shortest>elasticity*2) {
         reset++;
         n.x=px; n.y=py; }
    }
    return reset==nodes.size();
  }
}

/**
 * Simmple graph layout system
 * http://processingjs.nihongoresources.com/graphs
 * This code is in the public domain
 */

// This is a generic node in a graph
class Node
{
  ArrayList<Node> inlinks = new ArrayList<Node>();
  ArrayList<Node> outlinks = new ArrayList<Node>();;
  String label;
  String description;

  Node(String _label, int _x, int _y) {
    label=_label; x=_x; y=_y; r1=5; r2=5; }

  void addIncomingLink(Node n) {
    if(!inlinks.contains(n)) {
      inlinks.add(n);}}

  ArrayList<Node> getIncomingLinks(){
    return inlinks; }

  int getIncomingLinksCount() {
    return inlinks.size(); }

  void addOutgoingLink(Node n) {
    if(!outlinks.contains(n)) {
      outlinks.add(n);}}

  ArrayList<Node> getOutgoingLinks(){
    return outlinks; }

  int getOutgoingLinksCount() {
    return outlinks.size(); }

  float getShortestLinkLength() {
    if(inlinks.size()==0 && outlinks.size()==0) { return -1; }
    float l = 100;
    for(Node inode: inlinks) {
      int dx = inode.x-x;
      int dy = inode.y-y;
      float il = sqrt(dx*dx + dy*dy);
      if(il<l) { l=il; }}
    for(Node onode: outlinks) {
      int dx = onode.x-x;
      int dy = onode.y-y;
      float ol = sqrt(dx*dx + dy*dy);
      if(ol<l) { l=ol; }}
    return l; }

  boolean equals(Node other) {
    if(this==other) return true;
    return label.equals(other.label); }

  // visualisation-specific
  int x=0;
  int y=0;
  int r1=10;
  int r2=10;

  void setPosition(int _x, int _y) {
    x=_x; y=_y; }

  void setRadii(int _r1, int _r2) {
    r1=_r1; r2=_r2; }

  void draw() {
    stroke(0);
    fill(255);
    for(Node o: outlinks) {
      drawArrow(x,y,o.x,o.y); }
    ellipse(x,y,r1*2,r2*2);
    fill(50,50,255);
    text(label,x+r1*2,y+r2*2);
  }

  int[] arrowhead = {0,-4,0,4,7,0};
  void drawArrow(int x, int y, int ox, int oy)
  {
    int dx=ox-x;
    int dy=oy-y;
    float angle = getDirection(dx,dy);
    float vl = sqrt(dx*dx+dy*dy) - sqrt(r1*r1+r2*r2)*1.5;
    int[] end = rotateCoordinate(vl, 0, angle);
    line(x,y,x+end[0],y+end[1]);
    drawArrowHead(x+end[0], y+end[1], angle);
  }
  void drawArrowHead(int ox, int oy, float angle) {
    int[] rc1 = rotateCoordinate(arrowhead[0], arrowhead[1], angle);
    int[] rc2 = rotateCoordinate(arrowhead[2], arrowhead[3], angle);
    int[] rc3 = rotateCoordinate(arrowhead[4], arrowhead[5], angle);
    int[] narrow = {ox+ rc1[0], oy+ rc1[1], ox+ rc2[0], oy+ rc2[1], ox+ rc3[0], oy+ rc3[1]};
    stroke(0);
    fill(255);
    triangle(narrow[0], narrow[1], narrow[2], narrow[3], narrow[4], narrow[5]);
  }
}

/**
 * Simmple graph layout system
 * http://processingjs.nihongoresources.com/graphs
 * This code is in the public domain
 */

/**
 * Trees are actually a subset of directed graphs,
 * in which there is always one, and only one, way to
 * get from one node to another node (i.e. they are
 * "loop free" directed graphs)
 */
class Tree extends DirectedGraph
{
  Node root;
  Tree(Node r) {
    root = r;
    nodes.add(root);
    flower = new TreeFlowAlgorithm(); }

  Node getRoot() { return root; }

  void addChild(Node parent, Node child) {
    nodes.add(child);
    linkNodes(parent, child); }

  int getDepth() { return getDepth(root); }

  int getDepth(Node r)
  {
    if(r.getOutgoingLinksCount()==0) return 1;
    int d = 0;
    ArrayList<Node> outgoing = r.getOutgoingLinks();
    for(Node child: outgoing) {
      int dc = getDepth(child);
      if(dc>d) { d=dc; }}
    return 1+d;
  }
}

/**
 * Simmple graph layout system
 * http://processingjs.nihongoresources.com/graphs
 * This code is in the public domain
 */

/**
 * Flow algorithm for trees - only works for Trees
 */
class TreeFlowAlgorithm implements FlowAlgorithm
{

  // tree layout is fairly simpe: segment
  // the screen into as many vertical strips
  // as the tree is deep, then at every level
  // segment a strip in as many horizontal
  // bins as there are nodes at that depth.

  boolean reflow(DirectedGraph g)
  {
    if(g instanceof Tree) {
      Tree t = (Tree) g;
      int depth = t.getDepth();
      int vstep = (height-20)/depth;
      int vpos = 30;

      Node first = t.root;
      first.x = width/2;
      first.y = vpos;

      // breadth-first iteration
      ArrayList<Node> children = t.root.getOutgoingLinks();
      while(children.size()>0)
      {
        vpos += vstep;
        int cnum = children.size();
        int hstep = (width-20) / cnum;
        int hpos = 10 + (hstep/2);
        ArrayList<Node> newnodes = new ArrayList<Node>();
        for(Node child: children) {
          child.x = hpos;
          child.y = vpos;
          addAll(newnodes, child.getOutgoingLinks());
          hpos += hstep;
        }
        children = newnodes;
      }
    }
    return true;
  }
}

/**
 * Simmple graph layout system
 * http://processingjs.nihongoresources.com/graphs
 * This code is in the public domain
 */

// =============================================
//      Some universal helper functions
// =============================================

// universal helper function: get the angle (in radians) for a particular dx/dy
float getDirection(double dx, double dy) {
  // quadrant offsets
  double d1 = 0.0;
  double d2 = PI/2.0;
  double d3 = PI;
  double d4 = 3.0*PI/2.0;
  // compute angle basd on dx and dy values
  double angle = 0;
  float adx = abs((float)dx);
  float ady = abs((float)dy);
  // Vertical lines are one of two angles
  if(dx==0) { angle = (dy>=0? d2 : d4); }
  // Horizontal lines are also one of two angles
  else if(dy==0) { angle = (dx>=0? d1 : d3); }
  // The rest requires trigonometry (note: two use dx/dy and two use dy/dx!)
  else if(dx>0 && dy>0) { angle = d1 + atan(ady/adx); }    // direction: X+, Y+
  else if(dx<0 && dy>0) { angle = d2 + atan(adx/ady); }    // direction: X-, Y+
  else if(dx<0 && dy<0) { angle = d3 + atan(ady/adx); }    // direction: X-, Y-
  else if(dx>0 && dy<0) { angle = d4 + atan(adx/ady); }    // direction: X+, Y-
  // return directionality in positive radians
  return (float)(angle + 2*PI)%(2*PI); }

// universal helper function: rotate a coordinate over (0,0) by [angle] radians
int[] rotateCoordinate(float x, float y, float angle) {
  int[] rc = {0,0};
  rc[0] = (int)(x*cos(angle) - y*sin(angle));
  rc[1] = (int)(x*sin(angle) + y*cos(angle));
  return rc; }

// universal helper function for Processing.js - 1.1 does not support ArrayList.addAll yet
void addAll(ArrayList a, ArrayList b) { for(Object o: b) { a.add(o); }}

/**
 * Simmple graph layout system
 * http://processingjs.nihongoresources.com/graphs
 * This code is in the public domain
 */

// this is the interface for graph reflowing algorithms
interface FlowAlgorithm {
  // returns "true" if done, or "false" if not done
  boolean reflow(DirectedGraph g); }
