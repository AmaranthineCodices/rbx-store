local dependencies = {
	proptypes = {
		git = "https://github.com/AmaranthineCodices/rbx-prop-types.git",
		version = "master"
	}
}

local lfs = require("lfs")

lfs.mkdir("lib")
assert(lfs.chdir("lib"))

for name, dependency in pairs(dependencies) do
	os.execute(("git clone --depth=1 %s %s"):format(
		dependency.git,
		name
	))

	assert(lfs.chdir(name))
	os.execute(("git checkout %s"):format(
		dependency.version
	))

	assert(lfs.chdir(".."))
end