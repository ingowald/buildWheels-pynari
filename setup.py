from skbuild import setup  # This line replaces 'from setuptools import setup'
setup(
    name="pynari",
    version="1.0.8",
    description="ANARI Python Bindings",
    author='Ingo Wald',
#    license="MIT",
    packages=['pynari'],
    python_requires=">=3.8",
#install_requires="tbb-devel",

    package_data = {'': ("*.dll", "*.pyd", "*.so")},
    include_package_data=True,
)

