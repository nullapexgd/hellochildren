-- Remove the duplicate publication heading rendered from Markdown, then add
-- HTML-only back-cover copy from the repository's canonical synopsis file.

local function read_file(path)
    local handle, message = io.open(path, "r")

    if not handle then
        error("could not read synopsis file: " .. message)
    end

    local contents = handle:read("*a")
    handle:close()
    return contents
end

function Pandoc(document)
    local blocks = document.blocks

    if #blocks >= 4 then
        local title = pandoc.utils.stringify(blocks[1])

        if blocks[1].t == "Header" and blocks[1].level == 1 and title == "On Your Processor" then
            local first_body_block = 4

            if blocks[first_body_block] and blocks[first_body_block].t == "HorizontalRule" then
                first_body_block = first_body_block + 1
            end

            local filtered = pandoc.List()

            for index = first_body_block, #blocks do
                filtered:insert(blocks[index])
            end

            document.blocks = filtered
        end
    end

    if FORMAT:match("html") and document.meta["synopsis-file"] then
        local synopsis_path = pandoc.utils.stringify(document.meta["synopsis-file"])
        local synopsis = pandoc.read(read_file(synopsis_path), "markdown")
        local heading = pandoc.Header(2, "About the book", pandoc.Attr("back-cover-title", { "unlisted" }, {}))
        local back_cover_blocks = pandoc.List({ heading })
        back_cover_blocks:extend(synopsis.blocks)
        document.blocks:insert(pandoc.Div(
            back_cover_blocks,
            pandoc.Attr("back-cover", { "back-cover" }, {})
        ))
    end

    return document
end
