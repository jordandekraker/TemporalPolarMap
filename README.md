The goal of this project is to map the human temporal pole onto a polar flatmap. Similar in spirit to DeKraker et al., 2022, this can help with visualization, parcellation, and topologically-constrained inter-subject registration. 

Unlike DeKraker et al., this project uses a predefined cortical ribbon. This should be available through common MRI pipelines like [CIVET](https://mcin.ca/technology/civet/), [Freesurfer](https://surfer.nmr.mgh.harvard.edu/), or [Micapipe](https://micapipe.readthedocs.io/en/latest/).

The backbone of this tool is Choi et al.'s (2015) fast disk conformal mapping method, which we setup here for the temporal pole. First we find the apex of the temporal pole which is treated as the central 'anchor' point. We then map an ROI extending 50mm geodisically from that point. Finally, we map the masked surface to a disk in the coronal plane. Visualization (below) uses linear interpolation between native and flatmapped space.

![alt text](TPconformalMap.gif "Conformal map visualization")

TODO:
- [x] define ROI in example case
- [x] flatmap ROI in example case
- [ ] define and flatmap ROI in other common surfaces (CIVET; FS; Conte69, BigBrain)
- [ ] add thickness (repeat for pial and white surfaces)
- [ ] generate transform between native and flat space (interpolated and voxelized between surfaces)
- [ ] perform inter-subject registration in 2D

NOTES:
- Topological homology between subjects strongly depends on them having i) equivalent anchor points, and ii) roughly the same ROI (eg. 50mm geodesic distance may be a good choice in this sample brain but not in a larger or smaller sample)


REFERENCES:
DeKraker, Jordan, Stefan Köhler, and Ali R. Khan. "Surface-based hippocampal subfield segmentation." Trends in neurosciences 44, no. 11 (2021): 856-863.
Choi, Pui Tung, and Lok Ming Lui. "Fast disk conformal parameterization of simply-connected open surfaces." Journal of Scientific Computing 65, no. 3 (2015): 1065-1090.
