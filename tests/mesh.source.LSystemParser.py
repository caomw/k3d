#python

import testing

setup = testing.setup_mesh_source_test("LSystemParser")
setup.source.growth = 2
testing.mesh_comparison_to_reference(setup.document, setup.source.get_property("output_mesh"), "mesh.source.LSystemParser", 16, True)

