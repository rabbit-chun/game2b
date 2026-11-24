import bpy
import math
from mathutils import Vector
from pathlib import Path

# Procedural low-poly dream key. Run with Blender 5.x in background mode.
out = Path(__file__).resolve().parents[1] / "assets"
out.mkdir(exist_ok=True)
bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)

gold = bpy.data.materials.new("Moonlit Gold")
gold.diffuse_color = (0.95, 0.66, 0.24, 1)
gold.use_nodes = True
gold.node_tree.nodes["Principled BSDF"].inputs["Base Color"].default_value = (0.95, 0.55, 0.12, 1)
gold.node_tree.nodes["Principled BSDF"].inputs["Metallic"].default_value = 0.78
gold.node_tree.nodes["Principled BSDF"].inputs["Roughness"].default_value = 0.24
enamel = bpy.data.materials.new("Dream Enamel")
enamel.diffuse_color = (0.37, 0.28, 0.57, 1)
enamel.use_nodes = True
enamel.node_tree.nodes["Principled BSDF"].inputs["Base Color"].default_value = (0.32, 0.19, 0.53, 1)
enamel.node_tree.nodes["Principled BSDF"].inputs["Metallic"].default_value = 0.3

def cylinder(name, radius, depth, loc, material, vertices=12):
    bpy.ops.mesh.primitive_cylinder_add(vertices=vertices, radius=radius, depth=depth, location=loc, rotation=(math.pi/2,0,0))
    obj=bpy.context.object;obj.name=name;obj.data.materials.append(material)
    bevel=obj.modifiers.new("Soft crafted edges","BEVEL");bevel.width=.035;bevel.segments=2
    obj.modifiers.new("Weighted highlights","WEIGHTED_NORMAL")
    return obj

# Ring and enamel center face at the top, long shaft, two notched teeth.
cylinder("Key bow", .58, .22, (0,0,1.05), gold, 16)
cylinder("Enamel inset", .37, .235, (0,-.012,1.05), enamel, 12)
cylinder("Star seal", .12, .25, (0,-.02,1.05), gold, 6)
cylinder("Key shaft", .115, 2.15, (0,0,-.27), gold, 10)
cylinder("Lower tooth", .2, .14, (.19,0,-1.02), gold, 8)
cylinder("Upper tooth", .2, .14, (.19,0,-.67), gold, 8)
# Small spherical pommel at the tip.
bpy.ops.mesh.primitive_uv_sphere_add(segments=12, ring_count=8, radius=.16, location=(0,0,-1.43))
bpy.context.object.name="Key tip"
bpy.context.object.data.materials.append(gold)

for obj in bpy.context.scene.objects:
    obj.select_set(True)
bpy.context.view_layer.objects.active=bpy.context.scene.objects[0]
bpy.ops.wm.save_as_mainfile(filepath=str(out / "dream_key.blend"))
bpy.ops.export_scene.gltf(filepath=str(out / "dream_key.glb"), export_format='GLB', use_selection=False)
