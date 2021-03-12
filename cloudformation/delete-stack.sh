# ./delete-stack.sh my-test-stack ./eks-cluster.yml ./eks-cluster-params.json
aws cloudformation delete-stack \
--stack-name $1 \
