# Hub & Spoke Architecture

## 手順

1. Terraform 実行用サービスプリンシパルを作成
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret
</b>※サービスプリンシパルには、 `Contributor` を付与する必要がある。（[参考](https://docs.microsoft.com/ja-jp/azure/role-based-access-control/built-in-roles#contributor)）

```shell
$ az login
$ az account show --query "{subscriptionId:id, tenantId:tenantId}"
{
  "subscriptionId": "xxxxxx-xxxxxxxx-xxxxxxx-xxxxxxx",
  "tenantId": "xxxxx-xxxxxxx-xxxxxxx-xxxxxxx"
}
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/${SUBSCRIPTION_ID}"
``` 

2. 資格情報のテスト

```shell
$ az login --service-principal -u <SERVICE_PRINCIPAL_NAME> -p <PASSWORD> --tenant <TENANT_ID>
$ az vm list-sizes --location westus
```

3. Terraform の環境変数を構成
`./scripts/terraform-login-sample.sh` を参考に、 `./scripts/terraform-login.sh` を作成し、実行する。<br>
これにより、 Terraform 実行時は、サービスプリンシパルを認証に使用することが可能。（[参考](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)）

```shell:./scripts/terraform-login.sh
echo "Setting environment variables for Terraform"
export ARM_SUBSCRIPTION_ID=<your_subscription_id>
export ARM_CLIENT_ID=<your_appId>
export ARM_CLIENT_SECRET=<your_password>
export ARM_TENANT_ID=<your_tenant_id>
```

```shell
$ sudo chmod +x ./scripts/terraform-login.sh
$ ./scripts/terraform-login.sh
```

4. Terraform を実行

```shell
$ terraform init
$ terraform plan
$ terraform apply
```

## Tips
- サービスプリンシパルの資格情報リセット

```powershell
az ad sp credential reset --name <Service Principal Name>

Ex)
$ az ad sp credential reset --name terraform
The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
{
  "appId": "xxxxxx-xxxxxxx-xxxxx-xxxxx-xxxxxx",
  "name": "terraform",
  "password": "xxxxxxxxxxxx",
  "tenant": "xxxxxxxxxxxxxxxxxxxxxxx"
}
```

- サービスプリンシパルの名前を取得（<b>※サービスプリンシパルの displayName と servicePrincipalName は異なる。</b>）

```powershell
$ az ad sp list --filter "displayname eq 'terraform'"
[
  {
    "accountEnabled": "True",

    ・・・・

    "servicePrincipalNames": [
      "http://terraform",
      "xxxx-xxxx-xxxx-xxxx-xxxx"  ★
    ],
    "servicePrincipalType": "Application",

    ・・・・

    "tokenEncryptionKeyId": null
  }
]
```

## WIP
- 異なるリソースグループ間で VNet Peering を作成しようとすると、下記エラーが発生する。
    - 同一のリソースグループに変更することで回避可能だが、ワークロードを分割する際、要件を満たさないことがあるのではないか。

```shell
Error: network.VirtualNetworkPeeringsClient#CreateOrUpdate: Failure sending request: StatusCode=0 -- Original Error: Code="ResourceNotFound" Message="The Resource 'Microsoft.Network/virtualNetworks/hub-vnet' under resource group 'Spoke-1' was not found. For more details please go to https://aka.ms/ARMResourceNotFoundFix"
```

## To Do
- Bastion / VM の追加
- 各 VNet 間での疎通確認
- Hub への下記リソース追加
    - Hub
        - Azure Firewall
        - VPN Gateway
    - Others
        - Azure Monitor