import AppKit
let rep=NSBitmapImageRep(data:try! Data(contentsOf:URL(fileURLWithPath:"map.png")))!
let w=rep.pixelsWide,h=rep.pixelsHigh
let out=NSBitmapImageRep(bitmapDataPlanes:nil,pixelsWide:w,pixelsHigh:h,bitsPerSample:8,samplesPerPixel:4,hasAlpha:true,isPlanar:false,colorSpaceName:.calibratedRGB,bytesPerRow:w*4,bitsPerPixel:32)!
let bytes=out.bitmapData!;var red=Set<Int>();var px=[Int](repeating:0,count:4)
for y in 0..<h {for x in 0..<w {rep.getPixel(&px,atX:x,y:y);let r=px[0],g=px[1],b=px[2],i=(y*w+x)*4
bytes[i]=UInt8(r);bytes[i+1]=UInt8(g);bytes[i+2]=UInt8(b);bytes[i+3]=min(r,min(g,b))>242 ? 0:255
if r>160 && g<65 && b<65 {red.insert(y*w+x)}
}}
try! out.representation(using:.png,properties:[:])!.write(to:URL(fileURLWithPath:"assets/map.png"))
var cities=[[Double]]();while let p=red.first {var queue=[p],i=0;red.remove(p);var sx=0,sy=0;while i<queue.count {let q=queue[i];i+=1;sx+=q%w;sy+=q/w;for n in [q-1,q+1,q-w,q+w] {if red.remove(n) != nil {queue.append(n)}}};if queue.count>30 {cities.append([Double(sx)/Double(queue.count),Double(sy)/Double(queue.count),Double(queue.count)])}}
cities.sort{$0[1]<$1[1]};print(cities)
try! JSONSerialization.data(withJSONObject:cities,options:.prettyPrinted).write(to:URL(fileURLWithPath:"scripts/dots.json"))
