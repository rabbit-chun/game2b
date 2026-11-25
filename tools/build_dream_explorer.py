import bpy
import math
from mathutils import Vector
from pathlib import Path

ROOT = Path(r"C:\Users\rabbi\Documents\Game2b")
BLEND_OUT = ROOT / "assets" / "dream_explorer.blend"
GLB_OUT = ROOT / "godot" / "assets" / "dream_explorer.glb"

bpy.ops.object.select_all(action='SELECT')
bpy.ops.object.delete(use_global=False)
for material in list(bpy.data.materials):
    bpy.data.materials.remove(material)

# Blender scene uses Z as up; the character faces toward -Y.
def material(name, color, roughness=0.68, metallic=0.0):
    mat = bpy.data.materials.new(name)
    mat.diffuse_color = (*color, 1.0)
    mat.use_nodes = True
    bsdf = mat.node_tree.nodes.get("Principled BSDF")
    bsdf.inputs["Base Color"].default_value = (*color, 1.0)
    bsdf.inputs["Roughness"].default_value = roughness
    bsdf.inputs["Metallic"].default_value = metallic
    return mat

skin = material("Warm peach skin", (0.78, 0.43, 0.27))
hair = material("Midnight plum hair", (0.10, 0.12, 0.22))
hood = material("Golden rain hoodie", (0.96, 0.54, 0.12))
hood_light = material("Hood lining", (1.0, 0.76, 0.30))
trousers = material("Deep teal trousers", (0.12, 0.27, 0.31))
boots = material("Chestnut boots", (0.20, 0.10, 0.09))
backpack = material("Leaf green backpack", (0.24, 0.47, 0.31))
strap = material("Backpack straps", (0.78, 0.50, 0.23))
eyes = material("Dark eyes", (0.045, 0.035, 0.05), 0.25)

root = bpy.data.objects.new("DreamExplorer_3D", None)
bpy.context.collection.objects.link(root)
root.empty_display_type = 'CIRCLE'
root.empty_display_size = 0.08

def parent(obj):
    obj.parent = root
    return obj

def cube(name, loc, scale, mat, bevel=0.06):
    bpy.ops.mesh.primitive_cube_add(size=1, location=loc)
    obj = bpy.context.object
    obj.name = name
    obj.dimensions = scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    if bevel:
        mod = obj.modifiers.new("Soft low-poly corners", 'BEVEL')
        mod.width = bevel
        mod.segments = 1
        bpy.context.view_layer.objects.active = obj
        bpy.ops.object.modifier_apply(modifier=mod.name)
    obj.data.materials.append(mat)
    return parent(obj)

def ico(name, loc, scale, mat, subdivisions=2):
    bpy.ops.mesh.primitive_ico_sphere_add(subdivisions=subdivisions, radius=1, location=loc)
    obj = bpy.context.object
    obj.name = name
    obj.scale = scale
    bpy.ops.object.transform_apply(location=False, rotation=False, scale=True)
    obj.data.materials.append(mat)
    return parent(obj)

def cylinder(name, loc, radius, depth, mat, vertices=8, rotation=None):
    bpy.ops.mesh.primitive_cylinder_add(vertices=vertices, radius=radius, depth=depth, location=loc, rotation=rotation or (0,0,0))
    obj = bpy.context.object
    obj.name = name
    obj.data.materials.append(mat)
    bevel = obj.modifiers.new("Tiny edge glint", 'BEVEL')
    bevel.width = 0.025
    bevel.segments = 1
    bpy.context.view_layer.objects.active = obj
    bpy.ops.object.modifier_apply(modifier=bevel.name)
    return parent(obj)

# Backpack first, behind the torso.
cube("Little satchel", (0, 0.22, 0.98), (0.52, 0.31, 0.57), backpack, 0.10)
cube("Satchel flap", (0, 0.045, 1.19), (0.42, 0.08, 0.19), hood_light, 0.055)
# Boots and short trousers.
cube("Left boot", (-0.19, -0.005, 0.12), (0.25, 0.38, 0.20), boots, 0.06)
cube("Right boot", (0.19, -0.005, 0.12), (0.25, 0.38, 0.20), boots, 0.06)
cube("Left leg", (-0.17, 0.0, 0.39), (0.22, 0.23, 0.42), trousers, 0.055)
cube("Right leg", (0.17, 0.0, 0.39), (0.22, 0.23, 0.42), trousers, 0.055)
# Rain hoodie and roomy sleeves.
cube("Hoodie body", (0, 0.0, 0.83), (0.66, 0.43, 0.63), hood, 0.12)
ico("Left sleeve", (-0.39, -0.015, 0.88), (0.18,0.21,0.30), hood, 2)
ico("Right sleeve", (0.39, -0.015, 0.88), (0.18,0.21,0.30), hood, 2)
cube("Hoodie pocket", (0, -0.226, 0.71), (0.29, 0.035, 0.14), hood_light, 0.035)
# Head, hair cap, ears and face details.
ico("Face", (0, -0.015, 1.47), (0.31,0.27,0.34), skin, 3)
ico("Hair cap", (0, 0.015, 1.69), (0.33,0.30,0.22), hair, 2)
ico("Left curl", (-0.25,-0.035,1.57), (0.12,0.20,0.19), hair, 2)
ico("Right curl", (0.25,-0.035,1.57), (0.12,0.20,0.19), hair, 2)
ico("Left ear", (-0.30,-0.015,1.45), (0.075,0.075,0.095), skin, 2)
ico("Right ear", (0.30,-0.015,1.45), (0.075,0.075,0.095), skin, 2)
ico("Left eye", (-0.105,-0.267,1.49), (0.035,0.027,0.045), eyes, 2)
ico("Right eye", (0.105,-0.267,1.49), (0.035,0.027,0.045), eyes, 2)
ico("Nose", (0,-0.292,1.425), (0.045,0.035,0.040), hood_light, 2)
# A small scarf knot makes the front orientation obvious.
cylinder("Scarf knot", (0,-0.24,1.12), 0.095, 0.14, hood_light, 6, (math.radians(90),0,0))
# Gentle rounded hood rim behind the head.
ico("Hood", (0,0.09,1.46), (0.38,0.31,0.40), hood_light, 2)
# Move hood behind the face by retaining it at positive Y; all geometry is low-poly and textured by material.

# Clean file presentation and export the complete model hierarchy.
bpy.ops.object.select_all(action='DESELECT')
root.select_set(True)
for obj in root.children:
    obj.select_set(True)
bpy.context.view_layer.objects.active = root
bpy.ops.wm.save_as_mainfile(filepath=str(BLEND_OUT))
bpy.ops.export_scene.gltf(filepath=str(GLB_OUT), export_format='GLB', use_selection=True, export_apply=True, export_materials='EXPORT')
print("DREAM_EXPLORER_EXPORTED", BLEND_OUT, GLB_OUT, "parts=", len(root.children))
