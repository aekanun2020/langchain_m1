FROM ubuntu:22.04
#FROM ubuntu:jammy
ENV PATH="/root/miniconda3/bin:${PATH}"
ARG PATH="/root/miniconda3/bin:${PATH}"
ENV PIP_DEFAULT_TIMEOUT=1000

RUN apt-get update && apt-get install -y wget build-essential && rm -rf /var/lib/apt/lists/*

RUN wget \
    https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh \
    && mkdir /root/.conda \
    && bash Miniconda3-latest-Linux-aarch64.sh -b \
    && rm -f Miniconda3-latest-Linux-aarch64.sh 

RUN conda update -n base -c defaults conda -y && conda --version

# Update the environment:
COPY langchain_ai.yaml .
COPY notebooks ./notebooks
RUN conda env update --name base --file langchain_ai.yaml

WORKDIR /home

EXPOSE 8888
#ENTRYPOINT ["conda", "run", "-n", "base", "jupyter", "notebook", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.password=''"]
CMD jupyter lab --ip=0.0.0.0 --port=8888 --no-browser --allow-root --NotebookApp.token=
