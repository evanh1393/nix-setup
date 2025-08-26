{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core
    kubectl
    kubectx
    kubernetes-helm
    kustomize
    k9s
    stern
    yq jq

    # Local clusters
    kind
    k3d
    # minikube # optional if you want VM-based local clusters

    # Shipping / scaffolding
    skaffold
    tilt

    # Config / GitOps
    helmfile
    fluxcd
    sops age
    kubeseal

    # Security / images
    trivy
    grype syft
    cosign
    skopeo
    crane

    # Auth helpers
    kubelogin
  ];

  # Fish completions: declarative instead of runtime shellInit
  environment.etc = {
    "fish/completions/kubectl.fish".text   = builtins.readFile "${pkgs.kubectl}/share/fish/vendor_completions.d/kubectl.fish";
    "fish/completions/helm.fish".text      = builtins.readFile "${pkgs.kubernetes-helm}/share/fish/vendor_completions.d/helm.fish";
    "fish/completions/kind.fish".text      = builtins.readFile "${pkgs.kind}/share/fish/vendor_completions.d/kind.fish";
    # you can add more (skaffold, flux) if you like:
    # "fish/completions/skaffold.fish".text = builtins.readFile "${pkgs.skaffold}/share/fish/vendor_completions.d/skaffold.fish";
  };
}

