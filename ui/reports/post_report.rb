module CustomReports
    def self.generate_post_report(users)
        total_attachments = 0
        table_contents = ""
        for user in users  # TODO: ensure post attributes are correct - especially post.attachments!
            for post in user.posts
                table_contents += "<tr><td>#{post.post_id}</td><td>#{post.title}</td><td>#{post.createdAt}</td><td>#{post.updatedAt}</td><td>#{post.attachmentsNamesArray.join(', ')}</td><td>#{post.attachments.length}</tr>"
                total_attachments += post.attachments.length
            end
        end

        html_content = 
        "<!DOCTYPE html>
        <html lang='en'>
        <head>
            <meta charset='UTF-8'>
            <meta name='viewport' content='width=device-width, initial-scale=1.0'>

            <title>Post Report</title>

            <style>
                body {
                    margin: 0;
                    background-color: #ffffff;
                    font-family: Arial, sans-serif;
                }

                .title {
                    width: 100%;
                    padding: 20px 0;
                    background-color: #323232;
                    color: #ffffff;
                    text-align: center;
                    font-size: 24px;
                    font-weight: bold;
                }

                .metadata {
                    width: 100%;
                    border-collapse: collapse;
                    font-size: 16px;
                }

                .metadata td {
                    width: 50%;
                    padding: 15px 15px;
                    border: 2px #ddd solid;
                }

                .report {
                    width: 100%;
                    border-collapse: collapse;
                    font-size: 14px;
                }

                .report th,
                .report td {
                    padding: 12px 15px;
                    text-align: left;
                    border: 1px solid #ddd;
                }

                .report thead {
                    background-color: #ba0c2f;
                    color: #ffffff;
                }

                .report th {
                    font-size: 16px;
                    font-weight: bold;
                }

                .report tbody tr:nth-child(even) {
                    background-color: #f3f3f3;
                }

                .end {
                    width: 100%;
                    box-sizing: border-box;
                    padding-top: 10px;
                    padding-bottom: 10px;
                    background-color: #ffe2e2;
                    border: 2px solid #D0D0D0;
                    text-align: center;
                    font-weight: bold;
                }
            </style>
        </head>

        <body>

            <header class='title'>
                Post Report
            </header>

            <table class='report'>
                <thead>
                    <tr>
                        <th>Post ID</th>
                        <th>Title</th>
                        <th>Created Date</th>
                        <th>Updated Date</th>
                        <th>Attachments</th>
                        <th>#</th>
                    </tr>
                </thead>

                <tbody> 
                #{table_contents}
                </tbody>
            </table>

            <div class='end'>
                Total number of attachments: #{total_attachments}
            </div>

        </body>
        </html>"

        File.write("post-report.html", html_content)
    end
end
