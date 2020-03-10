defmodule AwesomeGithubWeb.PageView do
  use AwesomeGithubWeb, :view


  def count_sublist(list_id, list_of_list) do
  	Enum.count(list_of_list, fn x -> x.parent_id == list_id end)
  end


  def count_repo(list_id, list_of_repo) do
  	Enum.count(list_of_repo, fn x -> x.listing_id == list_id end)
  end
end
