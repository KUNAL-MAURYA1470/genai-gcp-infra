import sys


def prepare_template(filename, project_name, region="us-central1"):
    lines = []
    with open(filename, "r") as fin:
        for line in fin:
            if "__PROJECT__" in line:
                line = line.replace("__PROJECT__", project_name)
            if "__REGION__" in line:
                line = line.replace("__REGION__", region)
            lines.append(line)
    with open(filename, "w") as fout:
        fout.writelines(lines)


yaml_templates = [
    "chatbot-api/k8s/deployment.yaml",
    "init-db/k8s/job.yaml",
    "load-embeddings/k8s/job.yaml",
]

for t in yaml_templates:
    if len(sys.argv) == 3:
        prepare_template(t, sys.argv[1], sys.argv[2])
    else:
        prepare_template(t, sys.argv[1])
