# Dependencies and Installation Instructions

This pipeline will only support 64-bit Linux and MacOS.

Previously, the pipeline required a CentOS or RHEL machine to run because of the complex list of dependencies. We are now opting for an Anaconda virtual environment, because we have discovered Bioconda support for BWA and FASTQC. Anaconda and the Conda package manager will be the hub and virtual environment for your work, and will ensure that everyone on the project is using the same software.

## Installing and Setting Up Anaconda

Download Anaconda3 version 4.3.1 (for Python 3.6) for the appropriate system here: https://www.continuum.io/downloads 

On UNIX-like systems, install with the following command:
`bash Anaconda3-4.3.1-Linux-x86_64.sh`

You are encouraged to use the `bash` command regardless whether or not you are in a bash shell. It is very important that Linux users do not run this with `sudo`, as it will confuse Anaconda, causing it to install in the `/root/` directory.

When prompted to append the Anaconda path to your system's `$PATH`, it is advised you say `[no]` unless you intend for Anaconda Python to overwrite your system Python.

Test by navigating to the installation directory, then navigating to `bin/` and running `conda --version`.

For example:

```
cd ~/anaconda3/bin
conda --version
```




## Symlinking Anaconda Commands

If you opted not to say `[no]` to adding Anaconda to your `$PATH` variables (which was advised) you may have to symlink common anaconda commands to continue using this guide.

Recall the installation location of Anaconda. If you went with the default paths it will be installed at `~/anaconda3` for Linux users. We want to symlink `conda`, `activate`, and `deactivate` so that we can manage virtual environments without messing with our system `$PATH` variables. Use the following commands to symlink the Anaconda commands. 

**NOTE:** Make sure these do not interfere with any existing shell commands and adjust if necessary. For most people, this will not be a problem.

```
sudo ln -s /home/<user>/anaconda3/bin/conda /usr/bin/conda
sudo ln -s /home/<user>/anaconda3/bin/activate /usr/bin/activate
sudo ln -s /home/<user>/anaconda3/bin/deactivate /usr/bin/deactivate
```

Test by running `conda --version` from outside the Anaconda installation directory.



## Creating a Virtual Environment

We will reference this document: https://conda.io/docs/using/envs.html#create-an-environment throughout.

To create an environment: `conda create --name guler python=3.5`  
To activate the environment: `source activate guler`  
To deactivate the environment: `source deactivate guler`  
To list environments: `conda info --envs`  
To remove an environment: `conda remove --name guler --all`  

After activating the environment, the command line will be prepended by `(guler) ` and the `$PATH` variable will be modified to point to `anaconda3/envs/guler/bin`. 

We will install dependencies to the virtual environment, so make sure the `(guler)` environment is active for the next steps.


## Installing Bioconda and Python Dependencies

Run these commands in order. This will install R, FastQC, bwa, delly, bedtools, and OpenCV 3, and give you access to over 3,000+ Bioconda packages that can be found here: https://bioconda.github.io/recipes.html


```
conda config --add channels conda-forge
conda config --add channels defaults
conda config --add channels r
conda config --add channels bioconda
conda install bwa
conda install fastqc
conda install bedtools
conda install delly

# Optional OpenCV install
# not currently needed in pipeline
conda install --channel menpo opencv3
```

## Using the Anaconda Environment

Now, whenever you are working on this project, make sure you are operating in the `(guler)` virtual environment. For example, if you are using RStudio, you will have to tweak the settings to get it to use Bioconda's vesion of R. When you are using the command line, make sure that you have activated the environment and `(guler)` is prepended to the command line.