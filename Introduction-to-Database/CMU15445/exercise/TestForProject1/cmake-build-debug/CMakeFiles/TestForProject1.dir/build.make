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
CMAKE_SOURCE_DIR = /mnt/f/Videos/CMU15445/exercise/TestForProject1

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /mnt/f/Videos/CMU15445/exercise/TestForProject1/cmake-build-debug

# Include any dependencies generated for this target.
include CMakeFiles/TestForProject1.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/TestForProject1.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/TestForProject1.dir/flags.make

CMakeFiles/TestForProject1.dir/main.cpp.o: CMakeFiles/TestForProject1.dir/flags.make
CMakeFiles/TestForProject1.dir/main.cpp.o: ../main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/mnt/f/Videos/CMU15445/exercise/TestForProject1/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/TestForProject1.dir/main.cpp.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/TestForProject1.dir/main.cpp.o -c /mnt/f/Videos/CMU15445/exercise/TestForProject1/main.cpp

CMakeFiles/TestForProject1.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/TestForProject1.dir/main.cpp.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /mnt/f/Videos/CMU15445/exercise/TestForProject1/main.cpp > CMakeFiles/TestForProject1.dir/main.cpp.i

CMakeFiles/TestForProject1.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/TestForProject1.dir/main.cpp.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /mnt/f/Videos/CMU15445/exercise/TestForProject1/main.cpp -o CMakeFiles/TestForProject1.dir/main.cpp.s

CMakeFiles/TestForProject1.dir/main.cpp.o.requires:

.PHONY : CMakeFiles/TestForProject1.dir/main.cpp.o.requires

CMakeFiles/TestForProject1.dir/main.cpp.o.provides: CMakeFiles/TestForProject1.dir/main.cpp.o.requires
	$(MAKE) -f CMakeFiles/TestForProject1.dir/build.make CMakeFiles/TestForProject1.dir/main.cpp.o.provides.build
.PHONY : CMakeFiles/TestForProject1.dir/main.cpp.o.provides

CMakeFiles/TestForProject1.dir/main.cpp.o.provides.build: CMakeFiles/TestForProject1.dir/main.cpp.o


# Object files for target TestForProject1
TestForProject1_OBJECTS = \
"CMakeFiles/TestForProject1.dir/main.cpp.o"

# External object files for target TestForProject1
TestForProject1_EXTERNAL_OBJECTS =

TestForProject1: CMakeFiles/TestForProject1.dir/main.cpp.o
TestForProject1: CMakeFiles/TestForProject1.dir/build.make
TestForProject1: CMakeFiles/TestForProject1.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/mnt/f/Videos/CMU15445/exercise/TestForProject1/cmake-build-debug/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable TestForProject1"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/TestForProject1.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/TestForProject1.dir/build: TestForProject1

.PHONY : CMakeFiles/TestForProject1.dir/build

CMakeFiles/TestForProject1.dir/requires: CMakeFiles/TestForProject1.dir/main.cpp.o.requires

.PHONY : CMakeFiles/TestForProject1.dir/requires

CMakeFiles/TestForProject1.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/TestForProject1.dir/cmake_clean.cmake
.PHONY : CMakeFiles/TestForProject1.dir/clean

CMakeFiles/TestForProject1.dir/depend:
	cd /mnt/f/Videos/CMU15445/exercise/TestForProject1/cmake-build-debug && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /mnt/f/Videos/CMU15445/exercise/TestForProject1 /mnt/f/Videos/CMU15445/exercise/TestForProject1 /mnt/f/Videos/CMU15445/exercise/TestForProject1/cmake-build-debug /mnt/f/Videos/CMU15445/exercise/TestForProject1/cmake-build-debug /mnt/f/Videos/CMU15445/exercise/TestForProject1/cmake-build-debug/CMakeFiles/TestForProject1.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/TestForProject1.dir/depend

