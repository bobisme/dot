function s
  set -lx last_kubectl (history --search --prefix --max=1 kubectl | head -n1)

  set -lx context (
    string match --regex '[-]{2}context[= ][-\w]+' "$last_kubectl" \
      | string replace ' ' '=' \
      | string split -m1 '=' \
      | tail -n1
  )

  set -lx namespace_arg (string match --regex '[-]{2}namespace[= ][-\w]+' "$last_kubectl")
    or set -lx namespace_arg (string match --regex '[-]{1}n[= ][-\w]+' "$last_kubectl")
  set -lx namespace (
      string replace ' ' '=' -- "$namespace_arg" \
      | string split -m1 '=' \
      | tail -n1
  )

  commandline "stern"
  commandline -it -- " --context="
  commandline -it -- (string escape -- "$context")
  if test -n "$namespace"
    commandline -it -- " --namespace="
    commandline -it -- (string escape -- "$namespace")
  end
  commandline -it -- " "
  commandline -f repaint
end

