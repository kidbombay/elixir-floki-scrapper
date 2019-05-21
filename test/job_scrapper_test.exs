defmodule JobScrapperTest do
  use ExUnit.Case
  doctest JobScrapper
  @url 'https://www.indeed.com/viewjob?jk=fb0cb865bc60f2b7&from=cobra&tk=1dbccvrnn1sav000&iaal=1'

  test "parse indeed details and compare to result" do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} = HTTPoison.get("https://www.indeed.com/viewjob?jk=fb0cb865bc60f2b7&from=cobra&tk=1dbccvrnn1sav000&iaal=1")
    {_, _, info_childrens} = body
      |> Floki.find(".jobsearch-JobComponent .jobsearch-JobInfoHeader-subtitle .jobsearch-InlineCompanyRating")
      |> List.first
    {_, _, [company]} = List.first(info_childrens)
    {_, _, [location]} = List.last(info_childrens)

    resp = JobScrapper.indeed_detail
    assert resp.company == company
    assert resp.location == location
  end

  test "check JobScrapper.indeed_detail with static values" do
    resp = JobScrapper.indeed_detail
    assert resp.company == "EPC Consultants, Inc."
    assert resp.location == "San Francisco, CA 94104"
  end
end
