//
//  vec3.swift
//  phonetest5
//
//  Created by Apple1 on 12/8/20.
//

import Foundation
import SceneKit


struct vec3{
    var x:Float
    var y:Float
    var z:Float
    init(_ _x:Float,_ _y:Float,_ _z:Float){
        x=_x
        y=_y
        z=_z
    }
    init(_ _x:Double,_ _y:Double,_ _z:Double){
        x=Float(_x)
        y=Float(_y)
        z=Float(_z)
    }
    init(_ _v:SCNVector3){
        x=Float(_v.x)
        y=Float(_v.y)
        z=Float(_v.z)
    }
    func dot(_ v:vec3)->Float{
        return x*v.x+y*v.y+z*v.z
    }
    func cross(_ v:vec3)->vec3{
        return vec3(y*v.z-z*v.y,z*v.x-x*v.z,x*v.y-y*v.x)
    }
    func mag()->Float{
        return sqrt(x*x+y*y+z*z)
    }
    func normalize()->vec3{
        return self/mag()
    }
    func rotate(_ q:quaternion)->vec3{
        return (q*quaternion(0,self)*q.conj()).v
    }
    func toSCNV()->SCNVector3{
        return SCNVector3(x,y,z)
    }
}
prefix func -(v:vec3)->vec3{
    return -1.0*v
}


func +(_ u:vec3,_ v:vec3)->vec3{
    return vec3(u.x+v.x,u.y+v.y,u.z+v.z)
}
func -(_ u:vec3,_ v:vec3)->vec3{
    return vec3(u.x-v.x,u.y-v.y,u.z-v.z)
}
func *(_ a:Float,_ v:vec3)->vec3{
    return vec3(a*v.x,a*v.y,a*v.z)
}
func *(_ v:vec3,_ a:Float)->vec3{
    return vec3(a*v.x,a*v.y,a*v.z)
}
func /(_ a:Float,_ v:vec3)->vec3{
    return vec3(a/v.x,a/v.y,a/v.z)
}
func /(_ v:vec3,_ a:Float)->vec3{
    return vec3(v.x/a,v.y/a,v.z/a)
}

func *(_ b:Double,_ v:vec3)->vec3{
    let a=Float(b)
    return vec3(a*v.x,a*v.y,a*v.z)
}
func *(_ v:vec3,_ b:Double)->vec3{
    let a=Float(b)
    return vec3(a*v.x,a*v.y,a*v.z)
}
func /(_ b:Double,_ v:vec3)->vec3{
    let a=Float(b)
    return vec3(a/v.x,a/v.y,a/v.z)
}
func /(_ v:vec3,_ b:Double)->vec3{
    let a=Float(b)
    return vec3(v.x/a,v.y/a,v.z/a)
}

//func +=(_ u:vec3,_ v:vec3)->vec3{

class quaternion{
    var s:Float
    var v:vec3
    init(_ _s:Float,_ _v:vec3){
        s=_s
        v=_v
    }
    func toSCNQ()->SCNQuaternion{
        return SCNQuaternion(v.x,v.y,v.z,s)
    }
    func conj()->quaternion{
        return quaternion(s,-v)
    }
}

func +(_ u:quaternion,_ v:quaternion)->quaternion{
    return quaternion(u.s+v.s,u.v+v.v)
}
func -(_ u:quaternion,_ v:quaternion)->quaternion{
    return quaternion(u.s-v.s,u.v-v.v)
}
func *(_ a:quaternion,_ b:quaternion)->quaternion{
    return quaternion(a.s*b.s-a.v.dot(b.v),a.s*b.v+b.s*a.v+a.v.cross(b.v))
}

func *(_ a:quaternion,_ b:Float)->quaternion{
    return quaternion(b*a.s,b*a.v)
}
func *(_ b:Float,_ a:quaternion)->quaternion{
    return quaternion(b*a.s,b*a.v)
}
func /(_ a:quaternion,_ b:Float)->quaternion{
    return quaternion(a.s/b,a.v/b)
}
func /(_ b:Float,_ a:quaternion)->quaternion{
    return quaternion(b/a.s,b/a.v)
}

func *(_ a:quaternion,_ c:Double)->quaternion{
    let b=Float(c)
    return quaternion(b*a.s,b*a.v)
}
func *(_ c:Double,_ a:quaternion)->quaternion{
    let b=Float(c)
    return quaternion(b*a.s,b*a.v)
}
func /(_ a:quaternion,_ c:Double)->quaternion{
    let b=Float(c)
    return quaternion(a.s/b,a.v/b)
}
func /(_ c:Double,_ a:quaternion)->quaternion{
    let b=Float(c)
    return quaternion(b/a.s,b/a.v)
}

func angleAxis(_ t:Float,_ a:vec3)->quaternion{
    return quaternion(cos(t/2),sin(t/2)*a.normalize())
}

func proj(_ b:vec3,_ a:vec3)->vec3{
  return a.normalize()*b.dot(a.normalize());
}

func comp(_ b:vec3,_ a:vec3)->Float{
  return b.dot(a.normalize());
}

func getAngle(_ b:vec3,_ a:vec3)->Float{
  return acos(a.normalize().dot(b.normalize()));
}

func distance(_ b:vec3,_ a:vec3)->Float{
    return (a-b).mag()
}

func fromTo(_ a:vec3,_ b:vec3)->quaternion{
  return angleAxis(getAngle(a,b),a.normalize().cross(b.normalize()));
}
