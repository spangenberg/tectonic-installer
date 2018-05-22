require "json"

module AWS
  module_function

  def sts
    session_name = "#{`whoami`.strip}-#{Time.now.strftime("%Y%m%d-%H%M")}"
    account_id = JSON.parse(`aws sts get-caller-identity`)
      .fetch("Account")
    role_arn = "arn:aws:iam::#{account_id}:role/tf-tectonic-installer"
    credentials = JSON.parse(`aws sts assume-role --role-arn="#{role_arn}" --role-session-name="#{session_name}"`)
      .fetch("Credentials")

    ENV.update({ "AWS_ACCESS_KEY_ID" => credentials.fetch("AccessKeyId"),
                 "AWS_SECRET_ACCESS_KEY" => credentials.fetch("SecretAccessKey"),
                 "AWS_SESSION_TOKEN" => credentials.fetch("SessionToken") })
  end
end
