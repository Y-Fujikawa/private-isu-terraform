# private-isu-terraform

private-isuのネットワーク環境を構築するIaC

## 前提条件

- Terraform v1.0.10で動作確認済み
- 競技、ベンチマークインスタンスは構築しなおすことがあるため、手動で作成する。

## 使い方

```shell
cp variables.tf.sample variables.tf
# SSHを許可するIPアドレスに書き換える
vi variables.tf
terraform plan
terraform apply
```
