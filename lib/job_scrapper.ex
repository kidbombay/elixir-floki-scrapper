defmodule JobScrapper do
   def job_detail() do
    case HTTPoison.get(
           "https://www.ziprecruiter.com/jobs/metaoption-llc-a6a457c5/devops-automation-engineer-84ef9ba1"
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{
          title: Floki.find(body, ".job_description .job_header h1.job_title") |> Floki.text(),
          location: Floki.find(body, ".job_description .job_header .location_and_company .t_company_name a") |> Floki.text(),
          company: Floki.find(body, ".job_description .job_header .location_and_company .location_text span") |> Floki.text(),
          description: Floki.find(body, ".job_description .job_content .jobDescriptionSection div") |> Floki.text()
        }
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

   def zaali_detail() do
    case HTTPoison.get(
           "https://www.indeed.com/viewjob?jk=fb0cb865bc60f2b7&from=cobra&tk=1dbccvrnn1sav000&iaal=1"
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {_, _, info_childrens} = Floki.find(body, ".jobsearch-JobComponent .jobsearch-JobInfoHeader-subtitle .jobsearch-InlineCompanyRating")
        |> List.first

        {_, _, [company]} = List.first(info_childrens)
        {_, _, [location]} = List.last(info_childrens)

        %{
          title: Floki.find(body, ".jobsearch-JobComponent .jobsearch-DesktopStickyContainer h3.jobsearch-JobInfoHeader-title") |> Floki.text(),
          company: company,
          location: location,
          description: Floki.find(body, ".jobsearch-JobComponent .jobsearch-JobComponent-description") |> Floki.text(),
        }
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end
  end

end
