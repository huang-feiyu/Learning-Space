# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.10

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /mnt/f/Videos/CMU15445/exercise/testForProject0

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /mnt/f/Videos/CMU15445/exercise/testForProject0/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/testForProject0.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/testForProject0.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/testForProject0.dir/flags.make

CMakeFiles/testForProject0.dir/main.cpp.o: CMakeFiles/testForProject0.dir/flags.make
CMakeFiles/testForProject0.dir/main.cpp.o: ../main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/mnt/f/Videos/CMU15445/exercise/testForProject0/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/testForProject0.dir/main.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/testForProject0.dir/main.cpp.o -c /mnt/f/Videos/CMU15445/exercise/testForProject0/main.cpp

CMakeFiles/testForProject0.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/testForProject0.dir/main.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /mnt/f/Videos/CMU15445/exercise/testForProject0/main.cpp > CMakeFiles/testForProject0.dir/main.cpp.i

CMakeFiles/testForProject0.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/testForProject0.dir/main.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /mnt/f/Videos/CMU15445/exercise/testForProject0/main.cpp -o CMakeFiles/testForProject0.dir/main.cpp.s

CMakeFiles/testForProject0.dir/main.cpp.o.requires:

.PHONY : CMakeFiles/testForProject0.dir/main.cpp.o.requires

CMakeFiles/testForProject0.dir/main.cpp.o.provides: CMakeFiles/testForProject0.dir/main.cpp.o.requires
	$(MAKE) -f CMakeFiles/testForProject0.dir/build.make CMakeFiles/testForProject0.dir/main.cpp.o.provides.build
.PHONY : CMakeFiles/testForProject0.dir/main.cpp.o.provides

CMakeFiles/testForProject0.dir/main.cpp.o.provides.build: CMakeFiles/testForProject0.dir/main.cpp.o


# Object files for target testForProject0
testForProject0_OBJECTS = \
"CMakeFiles/testForProject0.dir/main.cpp.o"

# External object files for target testForProject0
testForProject0_EXTERNAL_OBJECTS =

testForProject0: CMakeFiles/testForProject0.dir/main.cpp.o
testForProject0: CMakeFiles/testForProject0.dir/build.make
testForProject0: CMakeFiles/testForProject0.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/mnt/f/Videos/CMU15445/exercise/testForProject0/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable testForProject0"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/testForProject0.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/testForProject0.dir/build: testForProject0

.PHONY : CMakeFiles/testForProject0.dir/build

CMakeFiles/testForProject0.dir/requires: CMakeFiles/testForProject0.dir/main.cpp.o.requires

.PHONY : CMakeFiles/testForProject0.dir/requires

CMakeFiles/testForProject0.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/testForProject0.dir/cmake_clean.cmake
.PHONY : CMakeFiles/testForProject0.dir/clean

CMakeFiles/testForProject0.dir/depend:
	cd /mnt/f/Videos/CMU15445/exercise/testForProject0/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /mnt/f/Videos/CMU15445/exercise/testForProject0 /mnt/f/Videos/CMU15445/exercise/testForProject0 /mnt/f/Videos/CMU15445/exercise/testForProject0/cmake-build-debug /mnt/f/Videos/CMU15445/exercise/testForProject0/cmake-build-debug /mnt/f/Videos/CMU15445/exercise/testForProject0/cmake-build-debug/CMakeFiles/testForProject0.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/testForProject0.dir/depend

