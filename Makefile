CXX      = g++
CXXFLAGS = -O3 -std=c++11

BBFS     = algorithms/bbfs/bbfs
ASEARCH  = algorithms/asearch/asearch
INDEX    = algorithms/index/Index
LVO_I    = algorithms/lvo_I/LVOI
LVO_II   = algorithms/lvo_II/LVOII

BINARIES = $(BBFS) $(ASEARCH) $(INDEX) $(LVO_I) $(LVO_II)

.PHONY: all clean
all: $(BINARIES)

$(BBFS): algorithms/bbfs/bbfs.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

$(ASEARCH): algorithms/asearch/asearch.cpp
	$(CXX) $(CXXFLAGS) $< -o $@

$(INDEX): algorithms/index/SignedKReachability.cpp algorithms/index/SignedKReachability.h
	$(CXX) $(CXXFLAGS) $< -o $@

$(LVO_I): algorithms/lvo_I/SignedKReachability.cpp algorithms/lvo_I/SignedKReachability.h
	$(CXX) $(CXXFLAGS) $< -o $@

$(LVO_II): algorithms/lvo_II/SignedKReachability.cpp algorithms/lvo_II/SignedKReachability.h
	$(CXX) $(CXXFLAGS) $< -o $@

clean:
	rm -f $(BINARIES)
